SELECT *
FROM EMP
WHERE SAL = (SELECT MIN(SAL) FROM EMP);

SELECT *
FROM EMP
WHERE DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = 'BLAKE');

SELECT *
FROM EMP
WHERE SAL IN (SELECT MIN(SAL) FROM EMP GROUP BY DEPTNO);

SELECT *
FROM EMP E1
WHERE SAL IN (SELECT MIN(SAL) FROM EMP E2 WHERE E1.DEPTNO = E2.DEPTNO);

SELECT *
FROM EMP
WHERE SAL > ANY (SELECT MIN(SAL) FROM EMP WHERE DEPTNO = 30);

SELECT *
FROM EMP
WHERE SAL > ALL (SELECT SAL FROM EMP WHERE DEPTNO = 30);

SELECT DEPTNO
FROM EMP
HAVING AVG(SAL) > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 30)
GROUP BY DEPTNO;

SELECT JOB
FROM EMP
HAVING AVG(SAL) >= ALL (SELECT AVG(SAL) FROM EMP GROUP BY JOB)
GROUP BY JOB;

SELECT *
FROM EMP
WHERE SAL > ALL (SELECT MAX(SAL)
                 FROM EMP
                          INNER JOIN DEPT ON DEPT.DEPTNO = EMP.DEPTNO
                 WHERE DEPT.DNAME = 'SALES');

SELECT *
FROM EMP E1
WHERE SAL > (SELECT AVG(SAL) FROM EMP E2 WHERE E1.DEPTNO = E2.DEPTNO);

SELECT *
FROM EMP E1
WHERE EXISTS(SELECT EMPNO FROM EMP E2 WHERE E2.MGR = E1.EMPNO);

SELECT *
FROM EMP
WHERE NOT EXISTS(SELECT * FROM DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO);

SELECT *
FROM EMP E1
WHERE HIREDATE IN (SELECT MAX(HIREDATE) FROM EMP E2 WHERE E1.DEPTNO = E2.DEPTNO)
ORDER BY HIREDATE;

SELECT ENAME, SAL, DEPTNO
FROM EMP E1
WHERE SAL > (SELECT AVG(SAL) FROM EMP E2 WHERE E1.DEPTNO = E2.DEPTNO);

SELECT *
FROM DEPT
WHERE NOT EXISTS(SELECT * FROM EMP WHERE EMP.DEPTNO = DEPT.DEPTNO);

SELECT DEPTNO, 100 * dzial / wszyscy
FROM (SELECT DEPTNO, COUNT(*) AS dzial FROM EMP GROUP BY DEPTNO),
     (SELECT COUNT(*) AS wszyscy FROM EMP);