variable "sq_admin_login" {
    default = "admin"
     description = "The login name for the admin user"
}

variable "sq_admin_login_password" {
  default = "admin"
   description = "The password for the admin user"
}

variable sq_host {
  description = "The hostname of the Sonarqube container instance"
}