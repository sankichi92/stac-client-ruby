# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib'

  repo_path 'gem_rbs_collection/gems'

  library 'forwardable', 'json', 'uri' # Standard libraries
  library 'faraday', 'stac' # Gems

  # configure_code_diagnostics(D::Ruby.strict)       # `strict` diagnostics setting
  # configure_code_diagnostics(D::Ruby.lenient)      # `lenient` diagnostics setting
  configure_code_diagnostics do |hash|
    hash[D::Ruby::MethodBodyTypeMismatch] = :information
    hash[D::Ruby::MethodDefinitionMissing] = nil # To supress noisy VS Code extension message.
    hash[D::Ruby::NoMethod] = :information
  end
end
