from logging.config import fileConfig
import sys
import os
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy import pool
from alembic import context

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from app.database import DATABASE_URL, Base
from app.models.tables import *

config = context.config
fileConfig(config.config_file_name)
target_metadata = Base.metadata


def run_migrations_offline():
    """Run migrations in 'offline' mode."""
    url = DATABASE_URL
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online():
    """Run migrations in 'online' mode."""
    connectable = create_async_engine(DATABASE_URL, poolclass=pool.NullPool)

    def do_run_migrations(sync_connection):
        context.configure(
            connection=sync_connection,
            target_metadata=target_metadata,
        )
        with context.begin_transaction():
            context.run_migrations()

    import asyncio
    async def async_main():
        async with connectable.connect() as connection:
            await connection.run_sync(do_run_migrations)

    asyncio.run(async_main())


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
