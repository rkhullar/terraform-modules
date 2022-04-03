resource "aws_iam_user" "default" {
  name          = var.name
  tags          = var.tags
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "default" {
  for_each   = var.policies
  user       = aws_iam_user.default.name
  policy_arn = each.value
}

resource "aws_iam_user_policy_attachment" "managed" {
  for_each   = var.managed_policies
  user       = aws_iam_user.default.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_iam_user_policy" "inline" {
  for_each = var.inline_policies
  user     = aws_iam_user.default.name
  name     = each.key
  policy   = each.value
}