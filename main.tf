resource "aws_iam_user" "users" {
  for_each = toset(var.users)
  name = "${each.key}"
}
resource "aws_iam_access_key" "access_key" {
for_each = toset(var.users)
user = "${each.key}"
depends_on = [
  aws_iam_user.users
]
}

resource "local_sensitive_file" "credentials" {
    for_each = toset(var.users)
    filename = "${each.key}-aws-credentials"
    content = "[default]\naws_access_key_id = ${aws_iam_access_key.access_key[each.key].id}\naws_secret_access_key = ${aws_iam_access_key.access_key[each.key].secret}\n"
    depends_on = [
        aws_iam_access_key.access_key
    ]
}
