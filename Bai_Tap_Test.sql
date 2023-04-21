USE QLKHO;
GO

--cau 1

create table Ton(
	MaVT nvarchar(20) primary key,
	TenVT nvarchar(50),
	SoLuongT int
);

create table Nhap(
	SoHDN int primary key,
	MaVT nvarchar(20) foreign key references Ton(MaVT),
	SoLuongN int,
	DonGiaN int,
	NgayN date
);

create table Xuat(
	SoHDX int primary key,
	MaVT nvarchar(20) foreign key references Ton(MaVT),
	SoLuongX int,
	DonGiaX int,
	NgayX date
);

INSERT INTO Ton(MaVT, TenVT, SoLuongT) VALUES ('VT001', 'Vật tư 1', 100);
INSERT INTO Ton(MaVT, TenVT, SoLuongT) VALUES ('VT002', 'Vật tư 2', 200);
INSERT INTO Ton(MaVT, TenVT, SoLuongT) VALUES ('VT003', 'Vật tư 3', 300);

INSERT INTO Nhap(SoHDN, MaVT, SoLuongN, DonGiaN, NgayN) 
VALUES (1, 'VT001', 50, 10000, '2023-04-20');
INSERT INTO Nhap(SoHDN, MaVT, SoLuongN, DonGiaN, NgayN) 
VALUES (2, 'VT002', 30, 15000, '2023-04-20');
INSERT INTO Nhap(SoHDN, MaVT, SoLuongN, DonGiaN, NgayN) 
VALUES (3, 'VT003', 20, 20000, '2023-04-20');

INSERT INTO Xuat(SoHDX, MaVT, SoLuongX, DonGiaX, NgayX) 
VALUES (1, 'VT001', 30, 15000, '2023-04-20');
INSERT INTO Xuat(SoHDX, MaVT, SoLuongX, DonGiaX, NgayX) 
VALUES (2, 'VT002', 40, 20000, '2023-04-20');
INSERT INTO Xuat(SoHDX, MaVT, SoLuongX, DonGiaX, NgayX) 
VALUES (3, 'VT003', 10, 25000, '2023-04-20');
INSERT INTO Xuat(SoHDX, MaVT, SoLuongX, DonGiaX, NgayX) 
VALUES (4, 'VT001', 20, 18000, '2023-04-21');


SELECT * FROM Ton;
SELECT * FROM Nhap;
SELECT * FROM Xuat;

--cau 2

CREATE FUNCTION ThongKeTienBan(@MaVT nvarchar(20), @NgayX date)
RETURNS TABLE
AS
RETURN
SELECT Ton.MaVT, Ton.TenVT, SUM(Xuat.SoLuongX * Xuat.DonGiaX) AS Tienban
FROM Xuat
INNER JOIN Ton ON Xuat.MaVT = Ton.MaVT
WHERE Ton.MaVT = @MaVT AND Xuat.NgayX = @NgayX
GROUP BY Ton.MaVT, Ton.TenVT

SELECT * FROM ThongKeTienBan('VT001', '2023-04-20')

--cau 3
CREATE FUNCTION ThongKeTongTienNhap(@MaVT nvarchar(20), @NgayN date)
RETURNS TABLE
AS
RETURN
SELECT Ton.MaVT, Ton.TenVT, SUM(Nhap.SoLuongN * Nhap.DonGiaN) AS Tiennhap
FROM Nhap
INNER JOIN Ton ON Nhap.MaVT = Ton.MaVT
WHERE Ton.MaVT = @MaVT AND Nhap.NgayN = @NgayN
GROUP BY Ton.MaVT, Ton.TenVT

SELECT * FROM ThongKeTongTienNhap('VT001', '2023-04-20')