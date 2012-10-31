module TokenGenerator
  def generate_initial_token(node_number, node_total)
    (node_number.to_i - 1) * ((2 ** 127) / node_total.to_i)
  end
end
