USE QLNV

----CÂU 1---

CREATE TABLE CHUCVU (
  maCV NVARCHAR(10) PRIMARY KEY,
  tenCV NVARCHAR(20)  NULL
);

CREATE TABLE NHANVIEN (
  maNV NVARCHAR(20) PRIMARY KEY,
  maCV NVARCHAR(10)  NULL,
  tenNV NVARCHAR(50)  NULL,
  ngaysinh DATETIME  NULL,
  luongCb FLOAT  NULL,
  ngaycong INT  NULL,
  phucap FLOAT  NULL
  FOREIGN KEY (maCV) REFERENCES CHUCVU(maCV)
);

INSERT INTO CHUCVU(maCV, tenCV) 
VALUES('BV', 'Bảo vệ'),
('GD', 'Giám đốc'),
('HC', 'Hành chính'),
('KT', 'Kế toán'),
('VS', 'Vệ sinh'),
('TQ', 'Thủ quỹ');

INSERT INTO NHANVIEN(maNV, maCV, tenNV, ngaysinh, luongCb, ngaycong, phucap) VALUES
('NV01', 'GD', N'Nguyễn Văn An', '12-12-1977', 700000, 25, 500000),
('NV02', 'BV', N'Bùi Văn Tí', '10-10-1978', 400000, 24, 100000),
('NV03', 'KT', N'Trần Thanh Nhật', '9-9-1977', 600000, 26, 400000),
('NV04', 'VS', N'Nguyễn Thị Út', '10-10-1980', 300000, 26, 300000),
('NV05', 'HC', N'Lê Thị Hà', '10-10-1979', 500000, 27, 200000)


---Câu 2----
--a
CREATE PROCEDURE SP_Them_Nhan_Vien 
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV VARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan DECIMAL(18,2),
  @NgayCong INT,
  @PhuCap DECIMAL(18,2)
AS
BEGIN
  IF EXISTS (SELECT * FROM CHUCVU WHERE maCV = @MaCV) AND DATEDIFF(YEAR, @NgaySinh, GETDATE()) <= 30
  BEGIN
    INSERT INTO NHANVIEN (maNV, maCV, tenNV, ngaysinh, luongCb, ngaycong, phucap)
    VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap);
    SELECT 'Thêm nhân viên thành công.' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT 'Không thể thêm nhân viên.' AS ThongBao;
  END
END

--b
CREATE PROCEDURE SP_CapNhat_Nhan_Vien 
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV VARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan DECIMAL(18,2),
  @NgayCong INT,
  @PhuCap DECIMAL(18,2)
AS
BEGIN
  IF EXISTS (SELECT * FROM CHUCVU WHERE maCV = @MaCV) AND DATEDIFF(YEAR, @NgaySinh, GETDATE()) <= 30
  BEGIN
    UPDATE NHANVIEN
    SET maCV = @MaCV, tenNV = @TenNV, ngaysinh = @NgaySinh, luongCb = @LuongCanBan, ngaycong = @NgayCong, phucap = @PhuCap
    WHERE maNV = @MaNV;
    SELECT 'Cập nhật nhân viên thành công.' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT 'Không thể cập nhật nhân viên.' AS ThongBao;
  END
END

--c
CREATE PROCEDURE SP_LuongLN
AS
BEGIN
  SELECT maNV, tenNV, luongCb*ngaycong+phucap AS Luong
  FROM NHANVIEN;
END

--d
CREATE FUNCTION TBL_LuongTB()
RETURNS TABLE 
AS
RETURN
(
  SELECT NHANVIEN.maNV, NHANVIEN.tenNV, CHUCVU.tenCV, NHANVIEN.luongCb*CASE WHEN ngaycong >= 25 THEN ngaycong*2 ELSE ngaycong END + phucap AS Luong
  FROM NhanVien
  INNER JOIN CHUCVU ON NHANVIEN.maCV = CHUCVU.maCV
  GROUP BY NHANVIEN.maNV, NHANVIEN.tenNV, CHUCVU.tenCV, NHANVIEN.luongCb, NHANVIEN.ngaycong, NHANVIEN.phucap
)

--1
CREATE PROCEDURE SP_ThemNhanVien
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhuCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM CHUCVU WHERE maCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM NHANVIEN WHERE maNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO NHANVIEN (maNV, maCV, tenNV, ngaysinh, luongCb, ngaycong, phucap)
	  VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhuCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END

--2
CREATE PROCEDURE ThemNhanVien
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhuCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM ChucVu WHERE maCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO NHANVIEN (maNV, maCV, tenNV, ngaysinh, luongCb, ngaycong, phucap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhuCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END

--3
CREATE PROCEDURE SP_CapNhatNgaySinh
  @MaNV VARCHAR(10),
  @NgaySinh DATE
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM NHANVIEN WHERE maNV = @MaNV;
  IF @Count = 0
  BEGIN
    SELECT 'Không tìm thấy bản ghi cần cập nhật' AS ThongBao;
  END
  ELSE
  BEGIN
    UPDATE NHANVIEN SET ngaysinh = @NgaySinh WHERE maNV = @MaNV;
    SELECT 'Cập nhật thành công' AS ThongBao;
  END
END

--4
CREATE PROCEDURE SP_TongSoNhanVienTheoNgayCong
  @NgayCong1 INT,
  @NgayCong2 INT
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM NHANVIEN
  WHERE ngaycong BETWEEN @NgayCong1 AND @NgayCong2;
END

--5
CREATE PROCEDURE SP_TongSoNhanVienTheoChucVu
  @TenCV NVARCHAR(50)
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM NHANVIEN
  WHERE maCV IN (SELECT maCV FROM CHUCVU WHERE tenCV = @TenCV);
END