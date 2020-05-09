#.global _Reset
_Reset:
	LDR sp, =stack_top
	BL c_entry
	BL _Reset
