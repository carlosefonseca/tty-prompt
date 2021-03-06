# encoding: utf-8

RSpec.describe TTY::Prompt::Question, '#echo' do

  subject(:prompt) { TTY::TestPrompt.new }

  it 'asks with echo on' do
    prompt.input << "password"
    prompt.input.rewind
    answer = prompt.ask("What is your password?") { |q| q.echo(true) }
    expect(answer).to eql("password")
    expect(prompt.output.string).to eq([
      "What is your password? ",
      "\e[1A\e[2K\e[1G",
      "What is your password? \e[32mpassword\e[0m\n"
    ].join)
  end

  it 'asks with echo off' do
    prompt.input << "password"
    prompt.input.rewind
    answer = prompt.ask("What is your password?", echo: false)
    expect(answer).to eql("password")
    expect(prompt.output.string).to eq([
      "What is your password? ",
      "\e[2K\e[1G",
      "What is your password? \n"
    ].join)
  end
end
