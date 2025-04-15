require 'faraday'

class TrixGeniusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def calculate_expression
    text = params.require(:text)
    calculus = call_ai_calculate_expression(text)
    render json: { calculus: calculus }
  rescue StandardError => e
    Rails.logger.error("Calculate Expression Error: #{e.message}")
    render json: { error: "An error occurred while CalculatingExpression." }, status: :unprocessable_entity
  end

  def correct_spelling
    text = params.require(:text)
    corrected_text = call_ai_check_spell(text)
    render json: { corrected_text: corrected_text }
  rescue StandardError => e
    Rails.logger.error("Orthography Correction Error: #{e.message}")
    render json: { error: "An error occurred while correcting orthography." }, status: :unprocessable_entity
  end



  private

  def evaluate_expression(expr)
    # Allow only numbers, operators, and parentheses
    allowed_chars = Set.new('0123456789+-*/(). '.chars)
    return nil unless expr.chars.all? { |c| allowed_chars.include?(c) }

    # Convert integers to floats for proper division
    sanitized = expr.gsub(/(\d+(?:\.\d+)?)/) { |m| m.include?('.') ? m : "#{m}.0" }

    begin
      result = eval(sanitized)
      # Convert whole numbers to integers for cleaner output
      result = result.to_i if result.is_a?(Float) && result == result.floor
      result
    rescue
      nil
    end
  end

  def process_text(text)
    stack = []
    expressions = []

    # Find all top-level parentheses expressions
    text.chars.each_with_index do |char, i|
      if char == '('
        stack.push(i)
      elsif char == ')' && stack.any?
        start_idx = stack.pop
        if stack.empty?  # Only track top-level parentheses
          expressions << { start: start_idx, end: i, expr: text[start_idx..i] }
        end
      end
    end

    # Process from last to first to preserve positions
    expressions.reverse.each do |exp|
      inner_expr = exp[:expr][1...-1]  # Remove outer parentheses
      result = evaluate_expression(inner_expr)
      
      next unless result

      replacement = "#{inner_expr}=#{result}"
      text = text[0...exp[:start]] + replacement + text[exp[:end]+1..-1]
    end

    text
  end

  def call_ai_calculate_expression(text)
    processed_text = process_text(text)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{Rails.application.config.deepseek[:api_key]}"
    }   

    body = {
      model: "deepseek-chat",
      messages: [{
        role: "user",
        content: "Format this text maintaining all original content but with calculated expressions: #{processed_text}"
      }],
      temperature: 0.7,
      max_tokens: 500
    }.to_json

    response = Faraday.post(Rails.application.config.deepseek[:api_url], body, headers)

    if response.success?
      str = JSON.parse(response.body)['choices'][0]['message']['content'].split("---")[1].gsub("*", "")
      return str
    else
      puts "Error: #{response.status} - #{response.body}"
    end
  end

  def call_ai_check_spell(text)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{Rails.application.config.deepseek[:api_key]}"
    }

    body = {
      model: "deepseek-chat",
      messages: [{ role: "user", content: "Correct this text: #{text}" }],
      temperature: 0.7,
      max_tokens: 500
    }.to_json

    response = Faraday.post(Rails.application.config.deepseek[:api_url], body, headers)

    if response.success?
      return JSON.parse(response.body)['choices'][1]['message']['content'].split('"')[1]
    else
      puts "Error: #{response.status} - #{response.body}"
    end
  end
end

