variable "private-key-data" {
  type = map
}

variable "web-01-ami" {
  type = string
}

variable "web-01-instance-type" {
  type = string
}

variable "webservers" {
  type = list(string)
  description = "List of web servers"
}