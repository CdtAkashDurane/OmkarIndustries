<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <title>OMKAR INDUSTRIES | Admin Dashboard</title>
    <style>
        :root { --primary: #FF5F15; --dark: #111; --light: #f4f4f4; }
        body { background: #eee; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; }
        .nav-admin { background: var(--dark); padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; color: white; }
        .card { max-width: 1000px; margin: 40px auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        
        /* Form & UI Styles */
        .form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; margin-bottom: 15px; }
        .btn-main { background: var(--primary); color: white; border: none; padding: 12px 20px; font-weight: bold; border-radius: 5px; cursor: pointer; transition: 0.3s; }
        .btn-main:hover { background: #e54e0d; }
        
        /* Modal Styles */
        .modal { display:none; position:fixed; z-index:2000; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.8); }
        .modal-content { background:white; margin:5% auto; padding:30px; width:85%; border-radius:10px; max-height: 85vh; overflow-y: auto; }
        
        /* Table Internal Styles */
        .col-name { width:100%; border:none; text-align:center; font-weight:bold; background: transparent; outline: none; }
        .cell-data { width:100%; border:none; padding:5px; text-align: center; outline: none; }
    </style>
</head>
<body>

    <nav class="nav-admin">
    <span style="color: var(--primary); font-weight: bold; font-size: 1.2rem;">OMKAR ADMIN</span>
    <div>
        <a href="${pageContext.request.contextPath}/admin/messages" style="color: white; margin-right: 20px; text-decoration: none; font-weight: bold;">
    <i class="fas fa-envelope"></i> View Messages
</a>
        <a href="manage-products.jsp" style="color: #FF7F00; margin-right: 20px; text-decoration: none; font-weight: bold;">
            <i class="fas fa-edit"></i> Manage Products
        </a>
        <a href="LogoutServlet" style="color: #ff4444; text-decoration: none; font-weight: bold;">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</nav>

    <div class="card">
        <h2 style="color: #333; margin-top: 0;">Upload New Product</h2>
        
        <form id="productForm" action="addProduct" method="post" enctype="multipart/form-data">
            <label>Product Name</label>
            <input type="text" name="name" class="form-control" required>
            
            <label>Category</label>
            <select name="category" class="form-control">
                <option>Radial Tyre Repairs</option>
                <option>Bias Ply Tyre Repairs</option>
                <option>Chemicals</option>
            </select>

            <label>Description</label>
            <textarea name="description" class="form-control" rows="3"></textarea>

            <div style="background: #f9f9f9; padding: 25px; border: 1px solid #ddd; border-radius: 8px; margin-top: 10px;">
                <h3 style="margin-top: 0; color: var(--primary);">Technical Specification Tables</h3>
                
                <div id="tables-container"></div>

                <button type="button" onclick="createNewTable()" class="btn-main" style="background: #333; width: 100%; margin-top: 10px;">
                    <i class="fas fa-plus"></i> Add New Table Section
                </button>
            </div>

            <div style="margin-top: 20px;">
                <label>Product Photo:</label><br>
                <input type="file" name="images" accept="image/*" required>
            </div>
            
            <input type="hidden" name="product_content" id="product_content">

            <div style="display: flex; gap: 10px; margin-top: 30px;">
                <button type="button" onclick="openPreview()" class="btn-main" style="background: #666; flex: 1;">Preview</button>
                <button type="submit" class="btn-main" style="flex: 2;">Publish Product</button>
            </div>
        </form>
    </div>

    <div id="previewModal" class="modal">
        <div class="modal-content">
            <h2 id="pName" style="color:var(--primary);"></h2>
            <div id="pTables"></div>
            <button type="button" onclick="document.getElementById('previewModal').style.display='none'" class="btn-main" style="background:#333; margin-top: 20px;">Close</button>
        </div>
    </div>

   <script>
    // 1. Function to Create a NEW Table Section
    function createNewTable() {
        const container = document.getElementById('tables-container');
        // Using a simple timestamp for unique IDs
        const uniqueId = "table_" + Date.now(); 
        
        const section = document.createElement('div');
        section.id = uniqueId;
        section.className = "table-section";
        section.style = "background: #fff; border: 1px solid #FF5F15; padding: 20px; border-radius: 8px; margin-bottom: 20px; position: relative;";
        
        // CRITICAL: We use \${uniqueId} to escape JSP EL evaluation
        section.innerHTML = `
            <button type="button" onclick="document.getElementById('\${uniqueId}').remove()" style="position: absolute; top: 10px; right: 10px; color: red; border: none; background: none; font-size: 1.2rem; cursor: pointer;">
                <i class="fas fa-trash"></i>
            </button>
            <input type="text" class="table-title" placeholder="Table Title (e.g. Passenger Car)" style="width: 90%; padding: 10px; margin-bottom: 15px; border: 1px solid #ddd;">
            
            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr class="header-row">
                            <th style="border: 1px solid #eee; padding: 8px; background: #f4f4f4;"><input type="text" class="col-name" value="Ref No"></th>
                            <th style="border: 1px solid #eee; padding: 8px; background: #f4f4f4;"><input type="text" class="col-name" value="Description"></th>
                            <th style="border: 1px solid #eee; padding: 8px; background: #f4f4f4;"><input type="text" class="col-name" value="Size mm"></th>
                            <th style="width:30px; background: #eee; border: 1px solid #eee;"></th>
                        </tr>
                    </thead>
                    <tbody class="row-container"></tbody>
                </table>
            </div>
            
            <div style="margin-top: 15px;">
                <button type="button" onclick="addColumn('\${uniqueId}')" style="background: #555; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; margin-right: 5px;">+ Add Column</button>
                <button type="button" onclick="addRow('\${uniqueId}')" style="background: #FF5F15; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer;">+ Add Row</button>
            </div>
        `;
        
        container.appendChild(section);
        addRow(uniqueId); 
    }

    // 2. Function to Add a Row
    function addRow(tableId) {
        const tableSection = document.getElementById(tableId);
        const tbody = tableSection.querySelector('.row-container');
        // Calculate columns based on the specific table's header
        const colCount = tableSection.querySelectorAll('.header-row th').length - 1; 
        
        const tr = document.createElement('tr');
        for(let i=0; i<colCount; i++) {
            const td = document.createElement('td');
            td.style = "border: 1px solid #eee; padding: 5px;";
            td.innerHTML = `<input type="text" class="cell-data">`;
            tr.appendChild(td);
        }
        
        const delTd = document.createElement('td');
        delTd.style = "text-align:center; border: 1px solid #eee;";
        delTd.innerHTML = `<button type="button" onclick="this.parentElement.parentElement.remove()" style="color:red; border:none; background:none; cursor:pointer;">&times;</button>`;
        tr.appendChild(delTd);
        
        tbody.appendChild(tr);
    }

    // 3. Function to Add a Column
    function addColumn(tableId) {
        const tableSection = document.getElementById(tableId);
        const headerRow = tableSection.querySelector('.header-row');
        const rows = tableSection.querySelectorAll('.row-container tr');
        const lastHeader = headerRow.lastElementChild;
        
        const th = document.createElement('th');
        th.style = "border: 1px solid #eee; padding: 8px; background: #f4f4f4;";
        th.innerHTML = `<input type="text" class="col-name" value="New Col">`;
        headerRow.insertBefore(th, lastHeader);
        
        rows.forEach(tr => {
            const td = document.createElement('td');
            td.style = "border: 1px solid #eee; padding: 5px;";
            td.innerHTML = `<input type="text" class="cell-data">`;
            // Insert before the delete cell
            tr.insertBefore(td, tr.lastElementChild);
        });
    }

    // Packaging Logic for Database
    document.getElementById('productForm').onsubmit = function() {
        const sections = document.querySelectorAll('.table-section');
        const result = Array.from(sections).map(sec => {
            const title = sec.querySelector('.table-title').value;
            const headers = Array.from(sec.querySelectorAll('.col-name')).map(h => h.value);
            const rows = Array.from(sec.querySelectorAll('.row-container tr')).map(tr => {
                let obj = {};
                tr.querySelectorAll('.cell-data').forEach((input, i) => {
                    obj[headers[i]] = input.value;
                });
                return obj;
            });
            return { tableTitle: title, tableData: rows };
        });
        document.getElementById('product_content').value = JSON.stringify(result);
        return true;
    };

    window.onload = createNewTable;
</script>
</body>
</html>