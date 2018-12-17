data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_iam_user" "foosbot-user" {
  name = "foosbot-user"
}

resource "aws_iam_access_key" "foosbot-user-key" {
  user = "${aws_iam_user.foosbot-user.name}"
}


resource "aws_security_group" "foosball-security-group" {
  name = "foosball-security-group"
  vpc_id = "${aws_vpc.foosbot-vpc.id}"

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}