# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# variables.tf 
#
# Purpose: The following file declares all variables used in this backend repository


/********** Provider Variables NOT OVERLOADABLE **********/
variable "region" {
  description = "Target region where artifacts are going to be created"
}

variable "tenancy_ocid" {
  description = "OCID of tenancy"
}

variable "user_ocid" {
  description = "User OCID in tenancy."
}

variable "fingerprint" {
  description = "API Key Fingerprint for user_ocid derived from public API Key imported in OCI User config"
}

variable "private_key_path" {
  description = "Private Key Absolute path location where terraform is executed"
}

/********** Provider Variables NOT OVERLOADABLE **********/

/********** Brick Variables **********/
/********** LPG Variables **********/
variable "from_network_compartment_name" {
  description = "Display Name of Compartment where the From Flow is coming"
}

variable "to_network_compartment_name" {
  description = "Display Name of Compartment where the to flow is coming towards"
}

variable "from_vcn_display_name" {
  description = "Display Name of from VCN"

}

variable "to_vcn_display_name" {
  description = "Display Name of to VCN"

}

variable "from_lpg_display_name" {
  description = "Display name of from LPG"
}

variable "to_lpg_display_name" {
  description = "Display name of to LPG"
}

variable "from_route_table_display_name" {
  description = "Display name of from Route Table"

}

variable "to_route_table_display_name" {
  description = "Display name of to Route Table"

}
/********** LPG Variables **********/
/********** Brick Variables **********/

