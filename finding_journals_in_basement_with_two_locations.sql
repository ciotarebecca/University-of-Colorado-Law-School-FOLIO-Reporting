-- distinct on is not always desired (because you can't see data quality issues)
-- but I used distinct on in order to run the report for my colleagues who
-- are not looking for data quality issues but just a list of titles
select distinct on(lsper_titles.hrid) lsper_titles.title, lsper_titles."name", everything."name"
-- I create the first subquery:
-- find the journals in the lsper location
  from (
	select i.hrid, i.title, l."name" 
	from folio_inventory.instance__t as i
	join folio_inventory.holdings_record__t as h on i.id = h.instance_id
	join folio_inventory.location__t as l on h.permanent_location_id = l.id
	join folio_inventory.item__t as item on h.id = item.holdings_record_id
	where l.code like 'lsper'
) lsper_titles -- give this new "table" a name (I called it lsper_titles)
--then, I create the second subquery
-- I found basically everything in our collection
join ( -- I join the two subqueries together
	select i.hrid, i.title, l."name",l.code
	from folio_inventory.instance__t as i
	join folio_inventory.holdings_record__t as h on i.id = h.instance_id
	join folio_inventory.location__t as l on h.permanent_location_id = l.id
	join folio_inventory.item__t as item on h.id = item.holdings_record_id
) everything --I name this new "table" everything
on lsper_titles.hrid = everything.hrid
where everything.code != 'lsper' --this is to make sure that I don't see lsper-only stuff
;
