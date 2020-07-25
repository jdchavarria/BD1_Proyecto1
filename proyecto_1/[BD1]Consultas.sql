
/*----------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------CONSULTAS-----------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------*/

/*--------------------- CONSULTA No.1-----------*/

SELECT DISTINCT e.nombre, e.apellido, e.telefono, count(ev.id_paciente)as pacientes
from EMPLEADO e, EVALUACION ev, PACIENTE p
WHERE ev.id_empleado = e.id_empleado and p.id_paciente = ev.id_paciente
group by e.nombre,e.apellido,e.telefono
order by pacientes desc;

/*-------------------CONSULTA No.2------------------*/

SELECT DISTINCT e.nombre, e.apellido,e.direccion,t.nombre as titulo
FROM EMPLEADO e
INNER JOIN EVALUACION ev
ON  e.id_empleado = ev.id_empleado
INNER JOIN TITULO t
ON t.id_titulo = e.id_titulo
LEFT JOIN PACIENTE p
ON p.id_paciente = ev.id_paciente
WHERE  e.genero = 'M' AND  to_char(ev.fecha,'YYYY') = '2016'
GROUP BY e.nombre,e.apellido,e.direccion,t.nombre
HAVING COUNT(ev.id_paciente) >3 ;

/*------------CONSULTA No.3---------*/
SELECT DISTINCT p.nombre, p.apellido,t.nombre as TRATAMIENTO, s.nombre AS SINTOMA
FROM PACIENTE p
INNER JOIN PACIENTE_TRATAMIENTO pt
ON pt.id_paciente = p.id_paciente
INNER JOIN TRATAMIENTO t
ON pt.id_tratamiento = t.id_tratamiento
INNER JOIN EVALUACION e
ON e.id_paciente = p.id_paciente
INNER JOIN EVALUACION_SINTOMA es
ON es.id_evaluacion = e.id_evaluacion
INNER JOIN SINTOMA s
ON s.id_sintoma = es.id_sintoma
WHERE t.nombre = 'Tabaco en polvo' and s.nombre= 'Dolor de cabeza'; 

/*--------------CONSULTA No.4------------------------------------*/
SELECT p.nombre,p.apellido, count(pt.id_tratamiento)as cantidad
from PACIENTE p
INNER JOIN PACIENTE_TRATAMIENTO pt
ON pt.id_paciente = p.id_paciente
INNER JOIN TRATAMIENTO t
ON t.id_tratamiento = pt.id_tratamiento and t.nombre = 'Antidepresivos'
group by p.nombre,p.apellido
order by cantidad desc
fetch first 5 rows only;


/*-----------CONSULTA No.5----------*/
SELECT DISTINCT 
p.nombre, p.apellido, p.direccion, COUNT(p.id_paciente) AS cantidad
FROM PACIENTE p
LEFT JOIN EVALUACION ev ON ev.id_paciente = p.id_paciente
LEFT JOIN PACIENTE_TRATAMIENTO tp ON tp.id_paciente = p.id_paciente
LEFT JOIN TRATAMIENTO t ON t.id_tratamiento = tp.id_tratamiento
WHERE ev.id_paciente IS NULL AND tp.id_tratamiento IS NOT NULL
GROUP BY p.id_paciente, p.nombre, p.apellido, p.direccion
HAVING COUNT(p.id_paciente) > 3
ORDER BY p.nombre;


/*-------------------CONSULTA No.6------------------------*/
SELECT d.nombre, count(ds.id_sintoma) as cantidad_de_sintomas, ds.rango
from DIAGNOSTICO d
INNER JOIN DIAGNOSTICO_SINTOMA ds
ON ds.id_diagnostico = d.id_diagnostico
WHERE ds.rango = '9'
GROUP BY d.nombre,ds.rango
ORDER BY cantidad_de_sintomas desc;


/*------------------------CONSULTA No.7--------------------------*/
SELECT distinct p.nombre,p.apellido,p.direccion
from PACIENTE p
INNER JOIN EVALUACION e
ON p.id_paciente = e.id_paciente
INNER JOIN EVALUACION_SINTOMA es
ON es.id_evaluacion = e.id_evaluacion
INNER JOIN SINTOMA s
ON s.id_sintoma = es.id_sintoma
INNER JOIN DIAGNOSTICO_SINTOMA ds
ON ds.id_sintoma = ds.id_sintoma
where ds.rango > 5
group by p.nombre, p.apellido, p.direccion
order by p.nombre, p.apellido;



/*-------------------------CONSULTA No.8-----------------*/
SELECT DISTINCT e.nombre, e.apellido,e.fecha_nacimiento, count(ev.id_paciente) as cantidad_pacientes
FROM EMPLEADO e
INNER JOIN EVALUACION ev
ON  e.id_empleado = ev.id_empleado
LEFT JOIN PACIENTE p
ON p.id_paciente = ev.id_paciente
WHERE  e.genero = 'F' AND  e.direccion = '1475 Dryden Crossing'
GROUP BY e.nombre,e.apellido,e.fecha_nacimiento
HAVING COUNT(ev.id_paciente) >2 
order by cantidad_pacientes desc;



/*---------------------CONSULTA No.9-----------------------------*/
SELECT distinct e.nombre,e.apellido, (count(ev.id_evaluacion)/(select count(ev.id_evaluacion) from
 EVALUACION ev WHERE to_char(ev.fecha,'YY') >= '17'))*100 AS porcentaje, count(ev.id_paciente) as cantidad
from EMPLEADO e
INNER JOIN EVALUACION ev
ON e.id_empleado = ev.id_empleado
WHERE to_char(ev.fecha,'YY') >= '17'
group by e.nombre, e.apellido
order by porcentaje desc;

/*--------------------CONSULTA No.10---------------------------*/
SELECT  t.nombre, count(e.nombre)/1000*100 as porcentaje
FROM TITULO t
INNER JOIN EMPLEADO e
ON t.id_titulo = e.id_titulo
GROUP BY t.nombre
order by porcentaje desc;

/*----------------------------CONSULTA EXTRA----------------------*/

SELECT TO_CHAR(ev.fecha,'YYYY') AS AÑO, TO_CHAR(ev.fecha,'MONTH') AS MES, p.nombre, p.apellido, COUNT(*) AS CANTIDAD_TRATAMIENTOS 
FROM PACIENTE p
INNER JOIN PACIENTE_TRATAMIENTO pt ON p.id_paciente = pt.id_paciente
INNER JOIN EVALUACION ev ON p.id_paciente = ev.id_paciente 
GROUP BY TO_CHAR(ev.fecha,'YYYY'), TO_CHAR(ev.fecha,'MONTH'), p.nombre, p.apellido
HAVING COUNT(*)=(SELECT MAX(CANTIDAD_TRATAMIENTOS) FROM (SELECT p.nombre, p.apellido, COUNT(*) AS CANTIDAD_TRATAMIENTOS FROM PACIENTE p
                INNER JOIN PACIENTE_TRATAMIENTO pt ON p.id_paciente = pt.id_paciente
                GROUP BY p.nombre, p.apellido))
UNION
SELECT TO_CHAR(ev.fecha,'YYYY') AS AÑO, TO_CHAR(ev.fecha,'MONTH') AS MES, p.nombre, p.apellido, COUNT(*) AS CANTIDAD_TRATAMIENTOS 
FROM PACIENTE p
INNER JOIN PACIENTE_TRATAMIENTO pt ON p.id_paciente = pt.id_paciente
INNER JOIN EVALUACION ev ON p.id_paciente = ev.id_paciente 
GROUP BY TO_CHAR(ev.fecha,'YYYY'), TO_CHAR(ev.fecha,'MONTH'), p.nombre, p.apellido
HAVING COUNT(*)=(SELECT MIN(CANTIDAD_TRATAMIENTOS) FROM (SELECT p.nombre, p.apellido, COUNT(*) AS CANTIDAD_TRATAMIENTOS FROM PACIENTE p
                INNER JOIN PACIENTE_TRATAMIENTO pt ON p.id_paciente = pt.id_paciente
                GROUP BY p.nombre, p.apellido))
ORDER BY CANTIDAD_TRATAMIENTOS DESC;