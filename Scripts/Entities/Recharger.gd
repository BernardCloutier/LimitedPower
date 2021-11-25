extends Area


export(float, 0, 15) var RechargeSpeed = 2.0

var _rechargeable_bodies = []



func _process(delta):
	for rechargeable in self._rechargeable_bodies:
		rechargeable.recharge(self.RechargeSpeed * delta)


func _on_body_entered(body):
	if body.has_method("recharge"):
		body.checkpoint = self.global_transform.origin
		_rechargeable_bodies.push_back(body)
	if self._rechargeable_bodies.size() > 0:
		$ChargeEffect.play()


func _on_body_exited(body):
	if body.has_method("recharge"):
		_rechargeable_bodies.erase(body)
	if self._rechargeable_bodies.size() == 0:
		$ChargeEffect.stop()
