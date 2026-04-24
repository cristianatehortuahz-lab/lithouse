<#-- Template for loading stylesheets in the head -->

<!-- vitro base styles (application-wide) -->
<link rel="stylesheet" href="${urls.base}/css/vitro.css" media="print" onload="this.media='all'" />
<noscript><link rel="stylesheet" href="${urls.base}/css/vitro.css" /></noscript>

${stylesheets.list()}

<#--temporary until edit controller can include this when needed -->
<link rel="stylesheet" href="${urls.base}/css/edit.css" media="print" onload="this.media='all'" />
<noscript><link rel="stylesheet" href="${urls.base}/css/edit.css" /></noscript>
