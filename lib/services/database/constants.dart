const String dbName = 'cattle.db';
const String cattleTable = 'cattle';
const String farmTable = 'farm';

const createFarmTable = '''
          CREATE TABLE IF NOT EXISTS "farm" (
            "id"	INTEGER NOT NULL,
            "name"	TEXT,
            PRIMARY KEY("id" AUTOINCREMENT)
          );
                              ''';

const createCattleTable = '''
        CREATE TABLE IF NOT EXISTS "cattle" (
          "id"	INTEGER NOT NULL,
          "tag"	TEXT NOT NULL,
          "farm_id"	INTEGER NOT NULL,
          FOREIGN KEY("farm_id") REFERENCES "farm"("id"),
          PRIMARY KEY("id" AUTOINCREMENT)
        );
                              ''';
