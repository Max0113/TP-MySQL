select *
from vehicule
Where kilometrage > (select AVG(kilometrage) FROM vehicule) ;

select AVG(kilometrage) FROM vehicule;

select * FROM vehicule;