/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.apache.stratos.cli.commands;

import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.stratos.cli.Command;
import org.apache.stratos.cli.RestCommandLineService;
import org.apache.stratos.cli.StratosCommandContext;
import org.apache.stratos.cli.exception.CommandException;
import org.apache.stratos.cli.utils.CliConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Un-deploy kubernetes cluster command.
 */
public class RemoveKubernetesClusterCommand implements Command<StratosCommandContext> {

    private static final Logger log = LoggerFactory.getLogger(RemoveKubernetesClusterCommand.class);

    public RemoveKubernetesClusterCommand() {
    }

    @Override
    public String getName() {
        return "remove-kubernetes-cluster";
    }

    @Override
    public String getDescription() {
        return "Remove kubernetes cluster";
    }

    @Override
    public String getArgumentSyntax() {
        return "[cluster-id]";
    }

    @Override
    public Options getOptions() {
        return null;
    }

    @Override
    public int execute(StratosCommandContext context, String[] args, Option[] alreadyParsedOpts) throws CommandException {
        if (log.isDebugEnabled()) {
            log.debug("Executing command: ", getName());
        }

        if ((args == null) || (args.length <= 0)) {
            context.getStratosApplication().printUsage(getName());
            return CliConstants.COMMAND_FAILED;
        }

        String clusterId = args[0];
        RestCommandLineService.getInstance().undeployKubernetesCluster(clusterId);
        return CliConstants.COMMAND_SUCCESSFULL;
    }
}
