-- Side / Extra items are prepared in the kitchen. The category had no zone,
-- so the legacy name fallback sent these items only to the counter printer.
DO $$
DECLARE
  main_kitchen_id uuid;
BEGIN
  SELECT id
  INTO main_kitchen_id
  FROM public.kitchen_zones
  WHERE active = true
    AND print_to_kitchen = true
    AND (lower(trim(name_en)) = 'main kitchen' OR trim(name_th) = 'อาหารหน้าร้าน')
  ORDER BY sort, id
  LIMIT 1;

  IF main_kitchen_id IS NULL THEN
    RAISE EXCEPTION 'Active Main Kitchen zone not found';
  END IF;

  UPDATE public.categories
  SET kitchen_zone_id = main_kitchen_id
  WHERE id = '9d126ce6-8cb4-4e14-94c1-e23afd27a2ac'
     OR lower(trim(coalesce(name_en, ''))) IN (
       '➕ side / extra', 'side / extra', 'side/extra', 'extra menu'
     )
     OR trim(coalesce(name_th, '')) IN (
       '➕ เครื่องเคียง / EXTRA', 'เครื่องเคียง / EXTRA', 'เครื่องเคียง'
     );
END $$;
