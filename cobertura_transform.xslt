<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="coverage/packages/package/classes/class/methods" />

  <xsl:template match="coverage/packages/package/classes/class">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
      <lines>
        <xsl:apply-templates select="methods/method/lines/line"/>
      </lines>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
