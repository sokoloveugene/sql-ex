select
    *
from
    Income_o full
    outer join Outcome_o on Income_o.point = Outcome_o.point
    and Income_o.date = Outcome_o.date