//
//  SettingsBuilder.swift
//  XcodeGen
//
//  Created by Yonas Kolb on 26/7/17.
//
//

import Foundation
import xcproj
import PathKit
import ProjectSpec
import Yams
import JSONUtilities

extension ProjectSpec {

    public func getProjectBuildSettings(config: Config) -> BuildSettings {

        var buildSettings: BuildSettings = [:]

        return buildSettings
    }

    public func getTargetBuildSettings(target: Target, config: Config) -> BuildSettings {
        var buildSettings = BuildSettings()

        return buildSettings
    }

    public func getBuildSettings(settings: Settings, config: Config) -> BuildSettings {
        var buildSettings: BuildSettings = [:]

        return buildSettings
    }

    // combines all levels of a target's settings: target, target config, project, project config
    public func getCombinedBuildSettings(basePath: Path, target: Target, config: Config, includeProject: Bool = true) -> BuildSettings {
        var buildSettings: BuildSettings = [:]
        if includeProject {
            if let configFilePath = configFiles[config.name] {
                if let configFile = try? XCConfig(path: basePath + configFilePath) {
                    buildSettings += configFile.flattenedBuildSettings()
                }
            }
            buildSettings += getProjectBuildSettings(config: config)
        }
        if let configFilePath = target.configFiles[config.name] {
            if let configFile = try? XCConfig(path: basePath + configFilePath) {
                buildSettings += configFile.flattenedBuildSettings()
            }
        }
        buildSettings += getTargetBuildSettings(target: target, config: config)
        return buildSettings
    }

    public func targetHasBuildSetting(_ setting: String, basePath: Path, target: Target, config: Config, includeProject: Bool = true) -> Bool {
        let buildSettings = getCombinedBuildSettings(basePath: basePath, target: target, config: config, includeProject: includeProject)
        return buildSettings[setting] != nil
    }
}

private var buildSettingFiles: [String: BuildSettings] = [:]

extension SettingsPresetFile {

    public func getBuildSettings() -> BuildSettings? {
        return nil
    }
}
