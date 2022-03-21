locals {
  alias_sources = [for source in var.sources: source if contains(keys(var.aliases), source)]
  normal_sources = [for source in var.sources: source if !contains(keys(var.aliases), source)]
}