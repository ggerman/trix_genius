class OrthographyController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /correct_orthography
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
      'Authorization' => "Bearer #{ENV['DEEPSEEK_API_KEY']}"
    }

    body = {
      model: "deepseek-chat",
      messages: [{ role: "user", content: "Correct this text: #{text}" }],
      temperature: 0.7,
      max_tokens: 500
    }.to_json

    response = Faraday.post(ENV['API_URL'], body, headers)

    if response.success?
      return JSON.parse(response.body)['choices'][0]['message']['content'].split('"')[1]
    else
      "Error: #{response.status} - #{response.body}"
    end
  end
end
