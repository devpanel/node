# Các biến thể Docker image của Node.js (v12 → v26)

Tài liệu tổng hợp các loại image (hệ điều hành nền) của `node` trên Docker Hub cho các phiên bản Node.js 12, 16, 18, 20, 22, 24 và 26.

- Nguồn: https://hub.docker.com/_/node và repo https://github.com/nodejs/docker-node
- Ngày tổng hợp: 10/11/2026
- Node 26, 24 và 22 lấy từ danh sách tag chính thức hiện tại.
- Node 20, 18, 16 và 12 đã EOL nên không còn trong danh sách chính thức. Phần này được ghép từ lịch sử repo và kiến thức có sẵn, **có thể thiếu một vài tag cũ**. Hãy kiểm tra lại trên Docker Hub nếu cần chắc chắn.

## Mục lục

- [Tổng quan](#tổng-quan)
- [Giải thích các loại image](#giải-thích-các-loại-image)
- [Node 26 (Lithium)](#node-26-lithium-lts)
- [Node 24 (Krypton)](#node-24-krypton-lts)
- [Node 22 (Jod)](#node-22-jod-lts)
- [Node 20 (Iron)](#node-20-iron-eol)
- [Node 18 (Hydrogen)](#node-18-hydrogen-eol)
- [Node 16 (Gallium)](#node-16-gallium-eol)
- [Node 12 (Erbium)](#node-12-erbium-eol)
- [Lưu ý và gợi ý chọn image](#lưu-ý-và-gợi-ý-chọn-image)

## Tổng quan

| Node | Tên mã | Debian mặc định | Alpine | Trạng thái |
|---|---|---|---|---|
| 26 | Lithium | trixie (13) | 3.23, 3.24 | LTS, hỗ trợ đến 04/2029 |
| 24 | Krypton | bookworm (12) | 3.23, 3.24 | LTS |
| 22 | Jod | bookworm (12) | 3.23, 3.24 | LTS |
| 20 | Iron | bookworm (12) | đến 3.23 | EOL (04/2026) |
| 18 | Hydrogen | bookworm (12) | đến 3.21 | EOL (04/2025) |
| 16 | Gallium | bullseye (11) | có | EOL (09/2023) |
| 12 | Erbium | buster (10) | có | EOL (04/2022) |

## Giải thích các loại image

Tên Debian ứng với số phiên bản:

| Tên mã | Phiên bản Debian |
|---|---|
| stretch | 9 |
| buster | 10 |
| bullseye | 11 |
| bookworm | 12 |
| trixie | 13 |

Các hậu tố và alias:

| Tag | Ý nghĩa |
|---|---|
| `node:<version>` | Bản mặc định (Debian), đầy đủ công cụ build như gcc, make, python |
| `-slim` | Debian rút gọn, chỉ có gói tối thiểu để chạy node, dung lượng nhỏ hơn nhiều |
| `-alpine` | Dựa trên Alpine Linux, rất nhỏ, dùng musl libc, mặc định không có git, bash |
| `-bookworm`, `-trixie`... | Chỉ định rõ bản Debian |
| `lithium`, `krypton`, `jod`... | Tên mã của dòng Node, dùng như alias (ví dụ `lithium-slim`) |
| `lts` | Trỏ tới bản LTS mới nhất (hiện tại là Node 26 `lithium`) |
| `current` | Trỏ tới bản Current mới nhất |

> `lithium` **không phải** hệ điều hành. Đây là tên mã của Node 26, giống như `krypton` là của Node 24.

## Node 18 (Hydrogen, EOL)

| Biến thể | Nền tảng | Ghi chú |
|---|---|---|
| `18` / `18-bookworm` | Debian 12 | Bản mặc định |
| `18-slim` / `18-bookworm-slim` | Debian 12 | Rút gọn |
| `18-bullseye` / `18-bullseye-slim` | Debian 11 | Đầy đủ / rút gọn |
| `18-buster` / `18-buster-slim` | Debian 10 | Ở các bản cũ |
| `18-alpine` | Alpine (đến 3.21) | Dùng musl libc |

## Lưu ý và gợi ý chọn image

- Node 18, 16 và 12 không còn nhận bản vá, nên cả Node lẫn hệ điều hành đều có lỗ hổng chưa được vá. Node 20 cũng đã hết hỗ trợ từ 04/2026. Không nên dùng cho production.
- Kiến trúc CPU khác nhau theo từng tag. Hãy kiểm tra trên Docker Hub nếu bạn chạy trên arm32, ppc64le hoặc s390x.
- Alpine dùng musl libc nên một số package native (ví dụ một số module cần build bằng node-gyp) có thể gặp lỗi.

Gợi ý chọn:

| Nhu cầu | Image gợi ý |
|---|---|
| Production ổn định, nhẹ | `node:26-trixie-slim` hoặc `node:lts-trixie-slim` |
| Dung lượng nhỏ nhất | `node:26-alpine` |
| Cần nhiều công cụ build sẵn | `node:26` |
| Pin phiên bản cụ thể | `node:26.13.0-trixie-slim` |

## Kiểm tra tag

```bash
# Lọc tag theo phiên bản trên Docker Hub
# https://hub.docker.com/_/node/tags?name=18

# Thử kéo image
docker pull node:18-bullseye-slim

# Xem hệ điều hành bên trong image
docker run --rm node:26-trixie-slim cat /etc/os-release
```