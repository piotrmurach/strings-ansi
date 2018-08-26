# frozen_string_literal: true

require_relative '../ansi'

module Strings
  module ANSI
    module Extensions
      refine String do
        def ansi?
          ANSI.ansi?(self)
        end

        def only_ansi?
          ANSI.only_ansi?(self)
        end

        def strip_ansi
          ANSI.strip_ansi(self)
        end
        alias sanitize strip_ansi
      end
    end # Extensions
  end # ANSI
end # Strings
