from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[2]


class MigrationTransactionTest(unittest.TestCase):
    def test_poll_backfill_holds_locks_until_migration_commits(self):
        migration = (
            ROOT
            / "supabase/migrations"
            / "20260903203142_restore_september_release_contracts.sql"
        ).read_text(encoding="utf-8").strip()

        self.assertTrue(migration.startswith("begin;\n"))
        self.assertTrue(migration.endswith("\ncommit;"))
        self.assertIn(
            "lock table core.polls, core.poll_options, core.poll_votes, core.poll_answers\n"
            "in share row exclusive mode;",
            migration,
        )


if __name__ == "__main__":
    unittest.main()
