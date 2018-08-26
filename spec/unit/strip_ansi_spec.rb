# frozen_string_literal: true

RSpec.describe Strings::ANSI, '#strip_ansi' do
  {
    "\e[20h" => '',
    "\e[?1h" => '',
    "\e[20l" => '',
    "\e[?9l" => '',
    "\eO"    => '',
    "\e[m"   => '',
    "\e[0m"  => '',
    "\eA"    => '',
    "\e[0;33;49;3;9;4m\e[0m" => ''
  }.each do |code, expected|
    it "remove #{code.inspect} from string" do
      expect(Strings::ANSI.strip_ansi(code)).to eq(expected)
    end
  end

  it "supports sanitize alias" do
    string = "\e[32mfoo\e[0m"
    expect(Strings::ANSI.sanitize(string)).to eq(Strings::ANSI.strip_ansi(string))
  end
end
