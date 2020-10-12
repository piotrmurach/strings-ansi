# frozen_string_literal: true

RSpec.describe Strings::ANSI, '#only_ansi?' do
  it "doesn't report empty string as having ansi codes" do
    expect(Strings::ANSI.only_ansi?('')).to eq(false)
  end

  it "doesn't report string without ansi" do
    expect(Strings::ANSI.only_ansi?("foo")).to eq(false)
  end

  it "doesn't report string containing ansi codes" do
    expect(Strings::ANSI.only_ansi?("\e[33;44mfoo\e[0m")).to eq(false)
  end

  it "reports string with only ansi codes correctly" do
    expect(Strings::ANSI.only_ansi?("\e[33;44m\e[0m")).to eq(true)
  end

  it "correctly checks string containing multiple lines" do
    expect(Strings::ANSI.only_ansi?("\n\e[33;44m\e[0m")).to eq(false)
    expect(Strings::ANSI.only_ansi?("\e[33;44m\e[0m\n")).to eq(false)
    expect(Strings::ANSI.only_ansi?("\n")).to eq(false)
    expect(Strings::ANSI.only_ansi?("\n\n")).to eq(false)
  end

  it "reports string containing hyperlink codes with an empty name" do
    expect(Strings::ANSI.only_ansi?("\e]8;;https://google.com\a\e]8;;\a")).to eq(true)
    expect(Strings::ANSI.only_ansi?("\e]8;;https://google.com\e\\\e]8;;\e\\")).to eq(true)
  end

  it "doesn't report string containing hyperlink codes with non-empty name" do
    expect(Strings::ANSI.only_ansi?("\e]8;;https://google.com\alabel\e]8;;\a")).to eq(false)
    expect(Strings::ANSI.only_ansi?("\e]8;;https://google.com\e\\label\e]8;;\e\\")).to eq(false)
  end
end
