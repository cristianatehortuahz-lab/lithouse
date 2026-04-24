<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#-- VIVO-specific default object property statement template.

     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.
-->

<#import "lib-meta-tags.ftl" as lmt>

<@showStatement statement />

<#macro showStatement statement>
    <#-- The query retrieves a type only for Persons. Post-processing will remove all but one. -->
  	<#if statement.subclass??>
		<#if statement.doi??>
			<a href="${statement.doi}" title="${i18n().name}">${statement.label!statement.localName!}</a>
		<#else>
			<a href="${profileUrl(statement.uri("object"))}" title="${i18n().name}">${statement.label!statement.localName!}</a>
		</#if>
	<#else>
		<#if statement.doi??>
    		<a href="${statement.doi}" title="${i18n().name}">${statement.label!statement.localName!}</a><span class="doc_type"> ${statement.title!statement.type!}</span>
		<#else>
			<a href="${profileUrl(statement.uri("object"))}" title="${i18n().name}">${statement.label!statement.localName!}</a><span class="doc_type"> ${statement.title!statement.type!}</span>
		</#if>
	</#if>
	<@lmt.addCitationMetaTag uri=(statement.specificObjectType) content=(statement.label!) />
</#macro>
