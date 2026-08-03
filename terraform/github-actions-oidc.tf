resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
    "6938fd4d98bab03faadb97b34396831e3780aea1",
  ]
}

data "aws_iam_policy_document" "github_actions_ardac_dict_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Su-informatics-lab/ardac-dict:ref:refs/tags/*"]
    }
  }
}

resource "aws_iam_role" "github_actions_ardac_dict_deployer" {
  name               = "github-actions-ardac-dict-deployer"
  description        = "Deploys tagged ardac-dict releases from GitHub Actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_ardac_dict_assume_role.json
}

data "aws_iam_policy_document" "github_actions_ardac_dict_deploy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::dictionary.ardac.org/*/schema.json"]
  }
}

resource "aws_iam_role_policy" "github_actions_ardac_dict_deploy" {
  name   = "deploy-dictionary-release"
  role   = aws_iam_role.github_actions_ardac_dict_deployer.id
  policy = data.aws_iam_policy_document.github_actions_ardac_dict_deploy.json
}

data "aws_iam_policy_document" "github_actions_alchepnet_website_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Su-informatics-lab/alchepnet-website:ref:refs/heads/develop"]
    }
  }
}

resource "aws_iam_role" "github_actions_alchepnet_website_deployer" {
  name               = "github-actions-alchepnet-website-deployer"
  description        = "Deploys the alchepnet-website develop branch from GitHub Actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_alchepnet_website_assume_role.json
}

data "aws_iam_policy_document" "github_actions_alchepnet_website_deploy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::test.alchepnet.org"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::test.alchepnet.org/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["arn:aws:cloudfront::${var.account}:distribution/EAIFBVSW6O5UF"]
  }
}

resource "aws_iam_role_policy" "github_actions_alchepnet_website_deploy" {
  name   = "deploy-website"
  role   = aws_iam_role.github_actions_alchepnet_website_deployer.id
  policy = data.aws_iam_policy_document.github_actions_alchepnet_website_deploy.json
}