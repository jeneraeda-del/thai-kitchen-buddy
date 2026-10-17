import fs from "node:fs";

const routing = fs.readFileSync("src/lib/print/routing.ts", "utf8");
const migration = fs.readFileSync(
  "supabase/migrations/20261016090000_route_side_extra_to_main_kitchen.sql",
  "utf8",
);

const checks = [
  [routing.includes("kitchen_zone_id?: string | null"), "category route accepts explicit zone"],
  [routing.includes("if (category.kitchen_zone_id) return false"), "explicit zone overrides legacy front fallback"],
  [migration.includes("9d126ce6-8cb4-4e14-94c1-e23afd27a2ac"), "known Side / Extra category is targeted"],
  [migration.includes("print_to_kitchen = true"), "migration selects a kitchen-printing zone"],
  [migration.includes("SET kitchen_zone_id = main_kitchen_id"), "Side / Extra is assigned to Main Kitchen"],
];

const failures = checks.filter(([ok]) => !ok).map(([, label]) => label);
if (failures.length) {
  console.error(`Extra kitchen routing regression failed: ${failures.join(", ")}`);
  process.exit(1);
}

console.log("Extra kitchen routing regression passed.");
