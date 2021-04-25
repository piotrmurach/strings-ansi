# frozen_string_literal: true

RSpec.describe Strings::ANSI, "#sanitize" do
  context "when string contains VT100 escape codes" do
    YAML.load_file(fixtures_path("ansi_codes.yaml")).each do |code|
      it "removes #{code.inspect} from #{('ansi' + code + 'code').inspect}" do
        expect(Strings::ANSI.sanitize("ansi#{code}code")).to eq("ansicode")
        expect(Strings::ANSI.sanitize("ansi#{code}1234")).to eq("ansi1234")
      end
    end
  end

  context "when string contains display attributes" do
    it "removes basic color codes" do
      expect(Strings::ANSI.sanitize("\e[1;33;44;91mfoo\e[0m")).to eq("foo")
    end

    it "removes 256 color codes" do
      expect(Strings::ANSI.sanitize("\e[38;5;255mfoo\e[0m")).to eq("foo")
    end

    it "removes 24-bit color codes" do
      expect(Strings::ANSI.sanitize("\e[48;2;255;255;255mfoo\e[0m")).to eq("foo")
    end

    it "removes erasing codes" do
      expect(Strings::ANSI.sanitize("\e[123Kfoo\e[0m")).to eq("foo")
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
