# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib'

  # library "pathname", "set"       # Standard libraries
  library 'stac' # Gems

  # configure_code_diagnostics(D::Ruby.strict)       # `strict` diagnostics setting
  # configure_code_diagnostics(D::Ruby.lenient)      # `lenient` diagnostics setting
  configure_code_diagnostics do |hash|
    hash[D::Ruby::MethodDefinitionMissing] = nil # To supress noisy VS Code extension message.
  end
end
