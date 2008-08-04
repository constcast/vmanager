<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml">

<xsl:output method="html"/>

<xsl:template match="/vermont">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="sensorData">
	<table class="sensorDataTable">
		<tr>
			<td>global data:</td>
			<td class="tcontainer">
				<table class="inner">
					<tr><td>process id</td><td><xsl:value-of select="pid"/></td></tr>
					<tr><td>time of sensor data</td><td><xsl:value-of select="@time"/></td></tr>
					<tr><td>time of previous access</td><td><xsl:value-of select="lastTime"/></td></tr>
					<tr><td>available processors</td><td><xsl:value-of select="processorAmount"/></td></tr>
					<xsl:for-each select="processor">
						<tr>
							<td>processor #<xsl:value-of select="@id" /> utilization (user/sys)</td>
							<td><xsl:value-of select="util[@type='user']"/> / <xsl:value-of select="util[@type='system']"/></td>
						</tr>
					</xsl:for-each>
					<tr><td>total memory</td><td><xsl:value-of select="memory/total div 1024"/> kB</td></tr>
					<tr><td>free memory</td><td><xsl:value-of select="memory/free div 1024"/> kB</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>module data:</td>
			<td class="tcontainer">
				<p align="center"><img src="%modulegraph_url%" /></p>
				<table class="inner">
					<tr><th>id</th><th width="15%">name</th><th width="10%">memory usage (in bytes)</th><th>additional info</th></tr>
					<xsl:apply-templates select="sensor[@type='module']" />
					<xsl:apply-templates select="sensor[@type='simple']" />
				</table>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="sensor">
	<tr>
		<td><xsl:value-of select="@id"/></td>
		<td><xsl:value-of select="@name"/></td> 
		<td><xsl:value-of select="memUsage"/></td>
		<td>
			<xsl:if test="thread">
				<div class="addinfoheader">thread info:</div>
				<table class="threadtable">
					<tr class="threadtable"><th class="threadtable">thread id</th><th class="threadtable">user utilization</th><th class="threadtable">system utilization</th></tr>
					<xsl:for-each select="thread">
						<tr class="threadtable">
							<td class="threadtable"><xsl:value-of select="@tid"/></td>
							<td class="threadtable"><xsl:value-of select="util[@type='user']"/></td>
							<td class="threadtable"><xsl:value-of select="util[@type='system']"/></td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>
			<xsl:if test="addInfo">
				<div class="addinfoheader">name/value info:</div>
				<table class="addinfotable">
					<tr class="addinfotable"><th class="addinfotable">name</th><th class="addinfotable">value</th></tr>
					<xsl:apply-templates select="addInfo/*" />
				</table>
			</xsl:if>
		</td>
	</tr>
</xsl:template>

<!-- additional information of sensors -->
<xsl:template match="addInfo/pcap">
	<tr class="addinfotable"><td class="addinfotable">PCAP received packets:</td><td class="addinfotable"><xsl:value-of select="received" /></td></tr>
	<tr class="addinfotable"><td class="addinfotable">PCAP dropped packets:</td><td class="addinfotable"><xsl:value-of select="dropped" /></td></tr>
</xsl:template>
<xsl:template match="addInfo/observer">
	<tr class="addinfotable"><td class="addinfotable">processed bytes:</td><td class="addinfotable"><xsl:value-of select="processed[@type='bytes']" /></td></tr>
	<tr class="addinfotable"><td class="addinfotable">processed packets:</td><td class="addinfotable"><xsl:value-of select="processed[@type='packets']" /></td></tr>
</xsl:template>
<xsl:template match="addInfo/entries">
	<tr class="addinfotable"><td class="addinfotable">entries in queue:</td><td class="addinfotable"><xsl:value-of select="." /></td></tr>
</xsl:template>
<xsl:template match="addInfo/createdInstances">
	<tr class="addinfotable"><td class="addinfotable">created instances:</td><td class="addinfotable"><xsl:value-of select="." /></td></tr>
</xsl:template>

</xsl:stylesheet>
