require 'faraday'

class TrixGeniusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def correct_spelling
    text = params.require(:text)

    corrected_text = call_ai_service(text)

    render json: { corrected_text: corrected_text }
  rescue StandardError => e
    Rails.logger.error("Orthography Correction Error: #{e.message}")
    render json: { error: "An error occurred while correcting orthography." }, status: :unprocessable_entity
  end

  private

  def call_ai_service(text)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{Rails.application.config.deepseek[:api_key}"
    }

    body = {
      model: "deepseek-chat",
      messages: [{ role: "user", content: "Correct this text: #{text}" }],
      temperature: 0.7,
      max_tokens: 500
    }.to_json

    response = Faraday.post(Rails.application.config.deepseek[:api_url],, body, headers)

    if response.success?
      return JSON.parse(response.body)['choices'][0]['message']['content'].split('"')[1]
    else
      "Error: #{response.status} - #{response.body}"
    end
  end
end
