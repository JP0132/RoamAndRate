"""Add toBeSplit to Expense table

Revision ID: 2eab7c2288eb
Revises: 
Create Date: 2025-10-29 17:36:06.962388

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '2eab7c2288eb'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
     # Add new column
    op.add_column('expenses', sa.Column('toBeSplit', sa.Boolean, nullable=False))


def downgrade():
    op.drop_column('expenses', 'toBeSplit')
