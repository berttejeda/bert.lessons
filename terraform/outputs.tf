output my_map_dot_notation {
  value = var.my_map.mykey
}

output my_map_key_notation {
  value = var.my_map["mykey"]
}