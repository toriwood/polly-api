require 'aws-sdk'

languages = ['English', 'Spanish', 'Italian']
language_code_mapping = { 'English' => 'en', 'Spanish' => 'es', 'Italian' => 'it' }
speakers_mapping = { 'English' => 'Joanna', 'Spanish' => 'Conchita', 'Italian' => 'Carla' }

puts '-----------Choose an input language-------------'
puts '----------------- 1) English -------------------'
puts '----------------- 2) Spanish -------------------'
puts '----------------- 3) Italian -------------------'

input = languages[gets.chomp.to_i - 1]
input_lang = language_code_mapping[input]

puts '----------Choose an output language-------------'
puts '----------------- 1) English -------------------'
puts '----------------- 2) Spanish -------------------'
puts '----------------- 3) Italian -------------------'

output = languages[gets.chomp.to_i - 1]

output_lang = language_code_mapping[output]
voice = speakers_mapping[output]

puts "Enter a phrase to translate:"
text = gets.chomp

if text.empty?
  puts "Oops, you didn't enter any text."
  exit
end

translator = Aws::Translate::Client.new
polly = Aws::Polly::Client.new

translated = translator.translate_text(
  text: text,
  source_language_code: input_lang,
  target_language_code: output_lang)

resp = polly.synthesize_speech({
  output_format: "mp3",
  text: translated.translated_text,
  voice_id: voice,
})

mp3_file = 'polly-api.mp3'
IO.copy_stream(resp.audio_stream, mp3_file)

puts "#{input}: #{text}"
puts "#{output}: #{translated.translated_text}"

`afplay ~/Desktop/polly-api.mp3`