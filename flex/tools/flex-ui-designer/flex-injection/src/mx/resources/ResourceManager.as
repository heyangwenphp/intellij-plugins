package mx.resources {
import com.intellij.flex.uiDesigner.ResourceBundleProvider;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.system.ApplicationDomain;
import flash.system.SecurityDomain;

import mx.utils.StringUtil;

public class ResourceManager extends EventDispatcher implements IResourceManager {
  private var resourceBundleProvider:ResourceBundleProvider;

  function ResourceManager(resourceBundleProvider:ResourceBundleProvider) {
    instance = this;
    this.resourceBundleProvider = resourceBundleProvider;
  }

  private static var instance:ResourceManager;
  //noinspection JSUnusedGlobalSymbols
  public static function getInstance():IResourceManager {
    return instance;
  }

  private var _localeChain:Array = ["en_US"];
  public function get localeChain():Array {
    return _localeChain;
  }
  public function set localeChain(value:Array):void {
    _localeChain = value;
  }

  public function loadResourceModule(url:String, update:Boolean = true, applicationDomain:ApplicationDomain = null,
                                     securityDomain:SecurityDomain = null):IEventDispatcher {
    return null;
  }

  public function unloadResourceModule(url:String, update:Boolean = true):void {
  }

  flex::gt_4_1
  public function addResourceBundle(resourceBundle:IResourceBundle, useWeakReference:Boolean = false):void {
  }

  flex::v4_1
  public function addResourceBundle(resourceBundle:IResourceBundle):void {
  }

  public function removeResourceBundle(locale:String, bundleName:String):void {
  }

  public function removeResourceBundlesForLocale(locale:String):void {
  }

  public function update():void {
    dispatchEvent(new Event(Event.CHANGE));
  }

  public function getLocales():Array {
    return _localeChain;
  }

  public function getPreferredLocaleChain():Array {
    return _localeChain;
  }

  public function getBundleNamesForLocale(locale:String):Array {
    throw new IllegalOperationError("unsupported");
  }

  public function getResourceBundle(locale:String, bundleName:String):IResourceBundle {
    return IResourceBundle(resourceBundleProvider.getResourceBundle(locale, bundleName, ResourceBundleImpl));
  }

  public function findResourceBundleWithResource(bundleName:String, resourceName:String):IResourceBundle {
    var n:int = _localeChain.length;
    for (var i:int = 0; i < n; i++) {
      var locale:String = localeChain[i];
      var bundle:IResourceBundle = getResourceBundle(locale, bundleName);
      if (bundle != null && resourceName in bundle.content) {
        return bundle;
      }
    }

    return null;
  }

  private function findBundle(bundleName:String, resourceName:String, locale:String):IResourceBundle {
    return locale == null ? findResourceBundleWithResource(bundleName, resourceName) : getResourceBundle(locale, bundleName);
  }

  public function getObject(bundleName:String, resourceName:String, locale:String = null):* {
    var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
    return resourceBundle == null ? undefined : resourceBundle.content[resourceName];
  }

  public function getString(bundleName:String, resourceName:String, parameters:Array = null, locale:String = null):String {
    var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
    if (resourceBundle == null) {
      return null;
    }

    var value:String = String(resourceBundle.content[resourceName]);
    return parameters == null ? value : StringUtil.substitute(value, parameters);
  }

  public function getStringArray(bundleName:String, resourceName:String, locale:String = null):Array {
    var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
    if (resourceBundle == null) {
      return null;
    }

    var array:Array = String(resourceBundle.content[resourceName]).split(",");
    var n:int = array.length;
    for (var i:int = 0; i < n; i++) {
      array[i] = StringUtil.trim(array[i]);
    }
    return array;
  }

  public function getNumber(bundleName:String, resourceName:String, locale:String = null):Number {
    var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
    return resourceBundle == null ? NaN : Number(resourceBundle.content[resourceName]);
  }

  public function getInt(bundleName:String, resourceName:String, locale:String = null):int {
    var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
    return resourceBundle == null ? 0 : int(resourceBundle.content[resourceName]);
  }

  public function getUint(bundleName:String, resourceName:String, locale:String = null):uint {
    var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
    return resourceBundle == null ? 0 : uint(resourceBundle.content[resourceName]);
  }

  public function getBoolean(bundleName:String, resourceName:String, locale:String = null):Boolean {
    var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
    return resourceBundle == null ? false : String(resourceBundle.content[resourceName]).toLowerCase() == "true";
  }

  public function getClass(bundleName:String, resourceName:String, locale:String = null):Class {
    var resourceBundle:IResourceBundle = findBundle(bundleName, resourceName, locale);
    return resourceBundle == null ? null : (resourceBundle.content[resourceName] as Class);
  }

  flex::gt_4_1
  public function installCompiledResourceBundles(applicationDomain:ApplicationDomain, locales:Array, bundleNames:Array,
                                                 useWeakReference:Boolean = false):Array {
    return null;
  }

  flex::v4_1
  public function installCompiledResourceBundles(applicationDomain:ApplicationDomain, locales:Array, bundleNames:Array):void {
  }

  public function initializeLocaleChain(compiledLocales:Array):void {
  }
}
}

import com.intellij.flex.uiDesigner.flex.ResourceBundle;

import flash.utils.Dictionary;

import mx.resources.IResourceBundle;

final class ResourceBundleImpl extends ResourceBundle implements IResourceBundle {
  public function ResourceBundleImpl(locale:String, bundleName:String, content:Dictionary) {
    super(locale, bundleName, content);
  }
}