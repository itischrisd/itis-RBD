SELECT DEPTNO, ENAME, MGR
FROM EMP;

SELECT *
FROM EMP;

SELECT ENAME, SAL * 12
FROM EMP;

SELECT ENAME, (SAL + 250) * 12
FROM EMP;

SELECT ENAME, (SAL) * 12 AS "ROCZNA"
FROM EMP;

SELECT ENAME, (SAL) * 12 AS "R PENSJA"
FROM EMP;

SELECT EMPNO || ' ' || ENAME AS "EMPLOYEE"
FROM EMP;

SELECT ENAME || ' pracuje w dziale ' || DEPTNO
FROM EMP;

SELECT ENAME, (SAL * 12 + NVL(COMM, 0))
FROM EMP;

SELECT DEPTNO
FROM EMP;

SELECT DISTINCT DEPTNO
FROM EMP;

SELECT DISTINCT DEPTNO, JOB
FROM EMP;

SELECT *
FROM EMP
ORDER BY ENAME;

SELECT *
FROM EMP
ORDER BY HIREDATE DESC;

SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, COMM, DEPTNO
FROM EMP
ORDER BY DEPTNO, SAL DESC;

SELECT ENAME, EMPNO, JOB, DEPTNO
FROM EMP
WHERE JOB = 'CLERK';

SELECT DNAME, DEPTNO
FROM DEPT
WHERE DEPTNO > 20;

SELECT *
FROM EMP
WHERE COMM > SAL;

SELECT *
FROM EMP
WHERE SAL BETWEEN 1000 AND 2000;

SELECT *
FROM EMP
WHERE MGR IN (7902, 7566, 7788);

SELECT *
FROM EMP
WHERE ENAME LIKE 'S%';

SELECT *
FROM EMP
WHERE LENGTH(ENAME) = 4;

SELECT *
FROM EMP
WHERE MGR IS NULL;

SELECT *
FROM EMP
WHERE NOT SAL BETWEEN 1000 AND 2000;

SELECT *
FROM EMP
WHERE NOT ENAME LIKE 'M%';

SELECT *
FROM EMP
WHERE MGR IS NOT NULL;

SELECT *
FROM EMP
WHERE JOB = 'CLERK'
  AND SAL >= 1000
  AND SAL < 2000;

SELECT *
FROM EMP
WHERE JOB = 'CLERK'
   OR SAL >= 1000 AND SAL < 2000;

SELECT *
FROM EMP
WHERE (JOB = 'MANAGER' AND SAL > 1500)
   OR JOB = 'SALESMAN';

SELECT *
FROM EMP
WHERE JOB = 'MANAGER'
   OR (JOB = 'SALESMAN' AND SAL > 1500);

SELECT *
FROM EMP
WHERE JOB = 'MANAGER'
   OR (JOB = 'CLERK' AND DEPTNO = 10);

SELECT *
FROM SALGRADE;

SELECT *
FROM DEPT;


SELECT DEPTNO, DNAME
FROM DEPT
ORDER BY DEPTNO;


SELECT DISTINCT JOB
FROM EMP;

SELECT *
FROM EMP
WHERE DEPTNO IN (10, 20)
ORDER BY ENAME;

SELECT *
FROM EMP
WHERE ENAME LIKE '%TH%'
   OR ENAME LIKE '%LL%';

SELECT ENAME, DEPTNO, HIREDATE
FROM EMP
WHERE EXTRACT(YEAR FROM HIREDATE) = 1980;

SELECT ENAME, (SAL * 12), COMM
FROM EMP
WHERE SAL > NVL(COMM, 0)
ORDER BY SAL DESC, ENAME;