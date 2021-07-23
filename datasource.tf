# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# datasource.tf 
#
# Purpose: The following script defines the lookup logic used in code to obtain pre-created resources in tenancy.

/********** Compartment and CF Accessors **********/
data "oci_identity_compartments" "FROMNWCOMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.from_network_compartment_name]
  }
}

data "oci_core_vcns" "FROMVCN" {
  compartment_id = local.from_nw_compartment_ocid
  filter {
    name   = "display_name"
    values = [var.from_vcn_display_name]
  }
}

data "oci_core_route_tables" "FROMRT" {
  compartment_id = local.from_nw_compartment_ocid
  filter {
    name   = "display_name"
    values = [var.from_route_table_display_name]
  }
}

data "oci_core_local_peering_gateways" "FROMLPG" {

  compartment_id = local.from_nw_compartment_ocid
  vcn_id         = local.from_vcn_ocid
  filter {
    name   = "display_name"
    values = [var.from_lpg_display_name]
  }
}


data "oci_identity_compartments" "TONWCOMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.to_network_compartment_name]
  }
}

data "oci_core_vcns" "TOVCN" {
  compartment_id = local.to_nw_compartment_ocid
  filter {
    name   = "display_name"
    values = [var.to_vcn_display_name]
  }
}

data "oci_core_route_tables" "TORT" {
  compartment_id = local.to_nw_compartment_ocid
  filter {
    name   = "display_name"
    values = [var.to_route_table_display_name]
  }
}

data "oci_core_local_peering_gateways" "TOLPG" {

  compartment_id = local.to_nw_compartment_ocid
  vcn_id         = local.to_vcn_ocid
  filter {
    name   = "display_name"
    values = [var.to_lpg_display_name]
  }
}

data "oci_identity_region_subscriptions" "home_region_subscriptions" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

locals {
  release = "1.0"

  # Compartment OCID Local Accessor
  from_nw_compartment_ocid = length(data.oci_identity_compartments.FROMNWCOMPARTMENTS.compartments) > 0 ? lookup(data.oci_identity_compartments.FROMNWCOMPARTMENTS.compartments[0], "id") : null
  to_nw_compartment_ocid   = length(data.oci_identity_compartments.TONWCOMPARTMENTS.compartments) > 0 ? lookup(data.oci_identity_compartments.TONWCOMPARTMENTS.compartments[0], "id") : null

  # VCN OCID Local Accessor
  from_vcn_ocid = lookup(data.oci_core_vcns.FROMVCN.virtual_networks[0], "id")
  to_vcn_ocid   = lookup(data.oci_core_vcns.TOVCN.virtual_networks[0], "id")

  # VCN CIDR Local Accessor
  from_vcn_cidr = lookup(data.oci_core_vcns.FROMVCN.virtual_networks[0], "cidr_block")
  to_vcn_cidr   = lookup(data.oci_core_vcns.TOVCN.virtual_networks[0], "cidr_block")


  # Peered LPG Local Accessor
  from_lpg_ocid = length(data.oci_core_local_peering_gateways.FROMLPG.local_peering_gateways) > 0 ? lookup(data.oci_core_local_peering_gateways.FROMLPG.local_peering_gateways[0], "id") : null
  to_lpg_ocid   = length(data.oci_core_local_peering_gateways.TOLPG.local_peering_gateways) > 0 ? lookup(data.oci_core_local_peering_gateways.TOLPG.local_peering_gateways[0], "id") : null

  # Associated Route Table 
  from_rt_ocid = lookup(data.oci_core_route_tables.FROMRT.route_tables[0], "id")
  to_rt_ocid   = lookup(data.oci_core_route_tables.TORT.route_tables[0], "id")
}