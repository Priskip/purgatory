--This file appends the gun.lua file.

--TRIGGER - TIMER
function add_projectile_trigger_and_timer(entity_filename, action_draw_count, delay_frames)
	if reflecting then
		Reflection_RegisterProjectile(entity_filename)
		return
	end

	BeginProjectile(entity_filename)
	BeginTriggerHitWorld()
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()

	BeginTriggerTimer(delay_frames)
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()
	EndProjectile()
end

-- TRIGGER - DEATH TRIGGER
function add_projectile_trigger_and_death_trigger(entity_filename, action_draw_count)
	if reflecting then
		Reflection_RegisterProjectile(entity_filename)
		return
	end

	BeginProjectile(entity_filename)
	BeginTriggerHitWorld()
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()

	BeginTriggerDeath()
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()
	EndProjectile()
end

-- TIMER - DEATH TRIGGER
function add_projectile_timer_and_death_trigger(entity_filename, action_draw_count, delay_frames)
	if reflecting then
		Reflection_RegisterProjectile(entity_filename)
		return
	end

	BeginProjectile(entity_filename)
	BeginTriggerTimer(delay_frames)
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()

	BeginTriggerDeath()
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()
	EndProjectile()
end

-- TRIGGER - TRIGGER
function add_projectile_trigger_and_trigger(entity_filename, action_draw_count)
	if reflecting then
		Reflection_RegisterProjectile(entity_filename)
		return
	end

	BeginProjectile(entity_filename)
	BeginTriggerHitWorld()
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()

	BeginTriggerHitWorld()
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()
	EndProjectile()
end

-- TIMER - TIMER
function add_projectile_timer_and_timer(entity_filename, action_draw_count, delay_frames)
	if reflecting then
		Reflection_RegisterProjectile(entity_filename)
		return
	end

	BeginProjectile(entity_filename)
	BeginTriggerTimer(delay_frames)
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()

	BeginTriggerTimer(delay_frames)
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()
	EndProjectile()
end

-- DEATH TRIGGER - DEATH TRIGGER
function add_projectile_death_trigger_and_death_trigger(entity_filename, action_draw_count)
	if reflecting then
		Reflection_RegisterProjectile(entity_filename)
		return
	end

	BeginProjectile(entity_filename)
	BeginTriggerDeath()
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()

	BeginTriggerDeath()
	draw_shot(create_shot(action_draw_count), true)
	EndTrigger()
	EndProjectile()
end