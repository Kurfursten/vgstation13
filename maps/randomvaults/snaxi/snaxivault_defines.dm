/************************************
            SNAXI VAULTS
    Please try to limit size to
    15x15 for ease of placement.

Included in this file
- Vault datums
- Vault atoms

************************************/

//Datums

/datum/map_element/snowvault
	type_abbreviation = "SV"
	var/base_turf_type = /turf/unsimulated/floor/snow

/datum/map_element/snowvault/initialize(list/objects)
	..(objects)
	existing_vaults.Add(src)

	var/zlevel_base_turf_type = get_base_turf(location.z)
	if(!zlevel_base_turf_type)
		zlevel_base_turf_type = /turf/space

	for(var/turf/new_turf in objects)
		if(new_turf.type == base_turf_type) //New turf is vault's base turf
			if(new_turf.type != zlevel_base_turf_type) //And vault's base turf differs from zlevel's base turf
				new_turf.ChangeTurf(zlevel_base_turf_type)

		new_turf.turf_flags |= NO_MINIMAP //Makes the spawned turfs invisible on minimaps

/datum/map_element/snowvault/cabin
	file_path = "maps/randomvaults/snaxi/cabin.dmm"

/datum/map_element/snowvault/crash
	file_path = "maps/randomvaults/snaxi/crash.dmm"

/datum/map_element/snowvault/kennel
	file_path = "maps/randomvaults/snaxi/kennel.dmm"

/datum/map_element/snowvault/grove
	file_path = "maps/randomvaults/snaxi/grove.dmm"

/datum/map_element/snowvault/hotspring
	file_path = "maps/randomvaults/snaxi/hotspring.dmm"

/datum/map_element/snowvault/deerfeeder
	file_path = "maps/randomvaults/snaxi/deerfeeder.dmm"

/datum/map_element/snowvault/wolfcave
	file_path = "maps/randomvaults/snaxi/wolfcave.dmm"

/datum/map_element/snowvault/thermalplant
	file_path = "maps/randomvaults/snaxi/thermalplant.dmm"

/datum/map_element/snowvault/construction_site
	file_path = "maps/randomvaults/snaxi/construction_site.dmm"

/datum/map_element/snowvault/santacabin
	file_path = "maps/randomvaults/snaxi/santacabin.dmm"

/datum/map_element/snowvault/frozenpond
	file_path = "maps/randomvaults/snaxi/frozenpond.dmm"

/datum/map_element/snowvault/rockysnow
	file_path = "maps/randomvaults/snaxi/rockysnow.dmm"

/datum/map_element/snowvault/bus_stop
	file_path = "maps/randomvaults/snaxi/bus_stop.dmm"

/datum/map_element/snowvault/buriedbody
	file_path = "maps/randomvaults/snaxi/buriedbody.dmm"

/datum/map_element/snowvault/guncache
	file_path = "maps/randomvaults/snaxi/guncache.dmm"

/datum/map_element/snowvault/mine_patch
	file_path = "maps/randomvaults/snaxi/mine_patch.dmm"

/datum/map_element/snowvault/lostsnowmobile
	file_path = "maps/randomvaults/snaxi/lostsnowmobile.dmm"

//Vault atoms

/area/vault/thermalplant
	name = "thermal plant"
	requires_power = 1

/area/vault/wolfcave
	name = "wolf cave"

/area/vault/kennel
	name = "kennels"

/area/vault/hotspring
	name = "hotspring"

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bahamamama/New()
	..()
	reagents.add_reagent(BAHAMA_MAMA, 30)

/area/vault/cabin
	name = "cabin"

/obj/machinery/space_heater/campfire/stove/fireplace/preset/New()
	..()
	new /obj/item/clothing/shoes(src) //create stockings
	cell.charge = cell.maxcharge