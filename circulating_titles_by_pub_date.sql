-- This query finds all Colorado Law's circulating print books (not in off-site storage)
-- and then orders them by publication date
-- I am publishing this query in order to show others in the FOLIO community how one might
-- go about this

-- Part 1: if you need to find location codes, you can use this
select ll.campus_name, ll.location_name, loc.code
from folio_derived.locations_libraries as ll
join folio_inventory.location__t as loc on ll.location_id = loc.id
where ll.campus_code = 'L' -- we are on the "L" or "Law Campus"
;

--Part 2: grab the title, the Publication Date from marc fields 264$c and 260$c, and the mat type
-- I added call number, instance hrid, and location to help us find it
select i.hrid, h.call_number as "Holdings Call Number", i.title as "Title", marc."content" as "Pub Date", l."name" , m."name" as "Mat Type"
from folio_inventory.instance__t as i
join folio_inventory.holdings_record__t as h on i.id = h.instance_id
join folio_inventory.location__t as l on h.permanent_location_id = l.id
join folio_inventory.item__t as item on h.id = item.holdings_record_id
join folio_inventory.material_type__t as m on item.material_type_id = m.id
join folio_source_record.marc__t as marc on i.id = marc.instance_id
where m.name = 'book'
 and l.code in ('lstb', 'lst2', 'lst1','lres','lresc')
 and ((marc.field = '264' and marc.sf='c') -- this is how you choose the marc field and its subfield
	or (marc.field ='260' and marc.sf ='c')) -- the parentheses show what criteria go together
  -- so (x OR y) and (260 and $c) and (264 and $c)
order by marc."content" ASC -- order earliest to latest
;

