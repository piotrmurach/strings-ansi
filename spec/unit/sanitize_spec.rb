# frozen_string_literal: true

RSpec.describe Strings::ANSI, "#sanitize" do
  {
    "\e[20h" => "",
    "\e[?1h" => "",
    "\e[20l" => "",
    "\e[?9l" => "",
    "\eO" => "",
    "\e[m" => "",
    "\e[0m" => "",
    "\eA" => "",
    "\e[0;33;49;3;9;4m\e[0m" => ""
  }.each do |code, expected|
    it "removes #{code.inspect} from string" do
      expect(Strings::ANSI.sanitize(code)).to eq(expected)
    end
  end

  context "when string contains hyperlink escape sequence" do
    it "removes escape codes and returns empty string when label is empty" do
      expect(Strings::ANSI.sanitize("\e]8;;https://google.com\e\\\e]8;;\e\\")).to eq("")
    end

    it "removes escape codes and returns label when is present" do
      expect(Strings::ANSI.sanitize("\e]8;;https://google.com\e\\label\e]8;;\e\\")).to eq("label")
    end

    it "removes escape codes correctly when params part is present" do
      expect(Strings::ANSI.sanitize("\e]8;key1=value1:key2=value2;https://google.com\alabel1\e]8;;\e\\")).to eq("label1")
      expect(Strings::ANSI.sanitize("\e]8;invalid-params;https://google.com\alabel2\e]8;;\e\\")).to eq("label2")
    end

    it "removes escape codes, leaving other characters that are not part of sequence" do
      expect(Strings::ANSI.sanitize("before_\e]8;;https://google.com\alabel\e]8;;\a_after")).to eq("before_label_after")
    end

    it "correctly removes escape codes when non-standard \\a terminator is used" do
      expect(Strings::ANSI.sanitize("before_\e]8;;https://google.com\alabel\e]8;;\e\\_after")).to eq("before_label_after")
    end
  end
end
