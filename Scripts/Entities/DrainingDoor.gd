extends DrainingChargeable


func is_full() -> bool:
	return .is_full() or get_node("..")._is_opened
