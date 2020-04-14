#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import print_function
import os
import re
import sys
import getopt
import fnmatch
import argparse


# Class for terminal Color
class tcolor:
    DEFAULT = "\033[0m"
    BOLD = "\033[1m"
    RED = "\033[91m"
    GREEN = "\033[92m"
    BLUE = "\033[96m"
    ORANGE = "\033[93m"
    MAGENTA = "\033[95m"



import collections


def IsInsideRepo(root_relative, repos, target_type=None):
    inside_repo=None
    #inside_repo_type=None

    parent=os.path.dirname(root_relative)
    while len(parent) > 1:
        #print parent
        if parent in repos:
            if target_type is None or target_type in repos[parent]:
                inside_repo=parent
                #inside_repo_type=repos[parent]
                break
            pass
        parent=os.path.dirname(parent)
        pass
    return inside_repo

 
#git rev-parse --show-toplevel
#/home/jedlund/GitReps/JPL/claraty_os
#altair:~/GitReps/JPL/claraty_os/.git$ git rev-parse --is-inside-git-dir
#true
#altair:~/GitReps/JPL/claraty_os/.git$ git rev-parse --is-inside-work-tree
#false
#altair:~/GitReps/JPL/claraty_os/.git$ git rev-parse --show-cdup



def searchAllRepositories():
    search_types = ["git","svn"]
    repos = {}

    curdir = os.path.abspath(os.getcwd())
    # First test to see if we are inside a git rep (svn has .svn in every dirctory, but git doesn't.)
    stdout, stderr,returncode = gitExecFull('.','git rev-parse --is-inside-git-dir')
    if returncode == 0:
        inside_git_dir = 'true' in stdout
        if inside_git_dir:
            print("You're inside a .git dir.")
            return repos
    
        inside_work_tree = 'true' in gitExec('.','git rev-parse --is-inside-work-tree')
        if inside_work_tree:
            # cdup = gitExec(curdir,'git rev-parse --show-cdup')
            show_toplevel = gitExec('.','git rev-parse --show-toplevel').strip()
            repos[show_toplevel] = set(["git"])
            pass
        pass
    for root, dirnames, filenames in os.walk(curdir):
        #root_relative = os.path.relpath(root)
        repo_types = set()
        for repo_type in search_types:
            repo_dir_name="."+repo_type
            if repo_dir_name in dirnames:
                repo_types.add(repo_type)
                pass
            pass
        if len(repo_types) == 0:
            if len(filenames) > 0:
                inside_repo = IsInsideRepo(root,repos)
                if inside_repo is not None:
                    continue
                pass
            else:
                continue
            pass
        repos[root]=repo_types
        #print repo_type, root_relative
        pass
    return repos

def process_remote_branch(rep,remote,remote_branch,local_branch, tracking, all_output, care_about_pulls=False):
    output = ""
    verbose_output = ""
    topush = getLocalToPush(rep, remote, remote_branch, local_branch)
    topull = getRemoteToPull(rep, remote, remote_branch, local_branch)
    count_topush = len(topush)
    count_topull = len(topull)
    ischange = (count_topush > 0) or (care_about_pulls and count_topull > 0)
    if ischange or all_output:
        output += " %s%s%s%s[" % (
            tcolor.ORANGE,
            remote,
            "/{}{}".format(remote_branch,"*" if tracking else "") if remote_branch != local_branch else "",
            tcolor.DEFAULT,
            )
        verbose_output += "  |--{}:{}/{}{} -- {}={}\n".format(local_branch,remote,remote_branch,"*" if tracking else "", remote, getRemoteUrl(rep,remote))
        if count_topush > 0:
            output += "%sTo Push:%s%s" % (
                tcolor.BLUE,
                tcolor.DEFAULT,
                count_topush
                )
            if count_topull >0:
                output += " "
                pass

            for commit in topush:
                verbose_output += "     |--%s[To Push]%s %s%s%s\n" % (
                    tcolor.MAGENTA,
                    tcolor.DEFAULT,
                    tcolor.BLUE,
                    commit,
                    tcolor.DEFAULT)
                pass
            pass
        if count_topull > 0:
            output += "%sTo Pull:%s%s" % (
                    tcolor.BLUE,
                    tcolor.DEFAULT,
                    count_topull
                )
            for commit in topull:
                verbose_output += "     |--%s[To Pull]%s %s%s%s\n" % (
                    tcolor.MAGENTA,
                    tcolor.DEFAULT,
                    tcolor.BLUE,
                    commit,
                    tcolor.DEFAULT)
                pass
            pass
        output += "]"
        pass
    return output, ischange, verbose_output


# Check state of a git repository
def checkRepository(rep, args):
    # Backward compability for options
    verbose = args.verbose # kwargs.get('verbose', False)
    checkremote = args.remote # kwargs.get('check_remote', False)
    ignoreBranch = args.ignore_branch # kwargs.get('ignore_branch', r'^$')
    non_default_branches = args.all_branches
    all_output=args.all_output
    care_about_pulls = args.pulls
    curdir = os.path.abspath(os.getcwd())
    gsearch = re.compile(r'^.?([A-Z]) (.*)')

    suggested_commands = ""

    if checkremote:
        updateRemote(rep)

    #changes = getLocalFilesChange(rep)
    #ischange = len(changes) > 0

    verbose_output = ""
    all_branch_output = ""
    ischange = False

    default_branch = getDefaultBranch(rep)
    local_branches = getLocalBranches(rep)
    remotes = getRemoteRepositories(rep)

    default_remotes_branches = getAllRemoteBranches(rep)
    add_comma = False
    for (default, branch) in [(True,default_branch),] + [(False,foo) for foo in local_branches if (foo != default_branch) and non_default_branches]:
        # print (default, branch)
        if re.match(ignoreBranch, branch):
            continue
        tracking_remote_and_branch = getTrackingRemoteAndBranch(rep,branch)
        check_remote_rbranch_tracking = []
        tracked = False
        if tracking_remote_and_branch:
            check_remote_rbranch_tracking = [(tracking_remote_and_branch[0],tracking_remote_and_branch[1],True)]
            # print("check_remote_rbranch_tracking=",check_remote_rbranch_tracking)
            tracked = True
            pass
        else:
            # WARNING this branch is not tracked
            pass
        check_remote_rbranch_tracking += [(r,branch,False) for r in remotes if ((not tracked) or r != tracking_remote_and_branch[0] or branch != tracking_remote_and_branch[1]) and hasRemoteBranch(rep,r,branch)]
        # print ("check_remote_rbranch_tracking=",check_remote_rbranch_tracking)
        # for r in remotes:
        #     if (not tracked) or r != tracking_remote_and_branch[0] or branch != [1]:
        #         if tracked:
        #             print(r,branch,check_remote_rbranch_tracking)
        #             print((not tracked), r != check_remote_rbranch_tracking[0],branch != check_remote_rbranch_tracking[1])
        #             pass
        #         check_remote_rbranch_tracking.append((r,branch,False)) 
        #         pass
        #     pass
        minPush = [None,None]
        #minPull = [None,None]
        for default_remote_branch in default_remotes_branches:
            topush = getLocalToPush(rep, default_remote_branch[1], default_remote_branch[2], branch)
            topull = getRemoteToPull(rep, default_remote_branch[1], default_remote_branch[2], branch)
            count_topush = len(topush)
            count_topull = len(topull)
            if minPush[0] is None or count_topush < minPush[0]:
                minPush[0] = count_topush
                minPush[1] = [(default_remote_branch[1], default_remote_branch[2])]
                pass
            elif count_topush == minPush[0]:
                minPush[1].append((default_remote_branch[1], default_remote_branch[2]))
                pass
        #branch_output = " {}{}:".format(branch,"*" if default else "")
        branch_output = " {}:".format(branch)
        if not tracked:
            branch_output += " %sNO TRACKING%s" % (tcolor.RED,tcolor.DEFAULT)
            if minPush[0] == 0:
                branch_output += "[matches %d remote branches]" % len(minPush[1])
                pass
            pass
        # # No need to display this since the branch is tracked.
        # if minPush[0]:
        #     print(branch,"minPush=",minPush)
        #     pass
        branch_verbose_output = ""
        branch_ischange = False
        if minPush[0]:
            branch_ischange = not tracked
            pass
        if not tracked and "origin" in remotes:
            if minPush[0]:
                suggested_commands += "    cd {}; pwd; git branch -u {}/{} {} ; cd - # setup tracking branch for local branch {}\n".format(rep, "origin",branch,branch, branch)
                #print(suggested_commands)
                pass
            else:
                suggested_commands += "    cd {}; pwd; git branch -d {} ; cd - # delete local branch {}\n".format(rep, branch, branch)
                pass
            pass
        for (remote,remote_branch,tracking) in check_remote_rbranch_tracking:
            # print ("  ",remote,remote_branch,tracking)
            output_temp,ischange_temp, verbose_output_temp = process_remote_branch(rep,remote,remote_branch,branch, tracking, all_output, default or care_about_pulls)
            if all_output and not output_temp:
                output_temp = " NO CHANGES"
                pass
            branch_output += output_temp
            branch_ischange = branch_ischange or ischange_temp
            branch_verbose_output += verbose_output_temp
            pass
        if branch_ischange or all_output:
            if add_comma:
                all_branch_output += ","
                pass
            all_branch_output += branch_output
            verbose_output += branch_verbose_output
            ischange = True
            add_comma = True
            pass
        elif default:
            if add_comma:
                all_branch_output += ","
                pass
            add_comma = True
            all_branch_output += branch_output + " NO CHANGES"
            pass
        pass

    changes = getLocalFilesChange(rep)
    if len(changes) > 0:
        strlocal = ""
        if add_comma:
            strlocal += ","
            pass
        strlocal += " %sLocal%s[" % (tcolor.ORANGE, tcolor.DEFAULT)
        strlocal += "%sTo Commit:%s%s" % (
            tcolor.BLUE,
            tcolor.DEFAULT,
            len(changes)
        )
        strlocal += "]"
        ischange = True

        verbose_output += "  |--Local\n"
        for c in changes:
            verbose_output += "     |--%s%s%s\n" % (
                tcolor.ORANGE,
                c[1],
                tcolor.DEFAULT)
            pass
        pass
    else:
        strlocal = ""
        pass

    if ischange:
        color = tcolor.BOLD + tcolor.RED
    else:
        color = tcolor.DEFAULT + tcolor.GREEN

    # Print result
    repo_path = rep if args.full_path  \
        else os.path.relpath(rep, curdir)
    prjname = "%s%s%s" % (color, repo_path, tcolor.DEFAULT) #TODO show relative directory here.
    # remoteString = getRemoteUrl(rep,"origin").strip()
    # if not remoteString:
    #     remoteString = " NO REMOTE"
    # else:
    #     remoteString = " "+remoteString
    #     pass
    
    #print("%(prjname)-60s/%(branch)s\t%(strlocal)s%(topush)s%(topull)s%(remoteString)s" % locals())
    if not args.clean or ischange or suggested_commands:
        print("%(prjname)-60s%(all_branch_output)s%(strlocal)s" % locals())
        if verbose:
            print(verbose_output,end='')
            pass
        if suggested_commands:
            print(" suggested_commands:")
            print(suggested_commands,end='')
            pass
        pass
    pass

def getLocalFilesChange(rep):
    files = []
    curdir = os.path.abspath(os.getcwd())
    snbchange = re.compile(r'^(.{2}) (.*)')
    result = gitExec(rep, "git status -suno"
                     % locals())

    lines = result.split('\n')
    for l in lines:
        m = snbchange.match(l)
        if m:
            files.append([m.group(1), m.group(2)])

    return files

def getTrackingRemoteAndBranch(rep, branch):
    result,stderr,returncode = gitExecFull(rep, "git rev-parse --symbolic-full-name %(branch)s@{u}"
                                           % locals())
    #refs/remotes/origin/master
    remote_branch_re = re.compile(r'^refs/remotes/([^/]+)/(\S+)')
    m = remote_branch_re.match(result)
    if m:
        return m.groups()
    return False


def hasRemoteBranch(rep, remote, branch):
    remote_branches = getRemoteBranches(rep,remote)
    return branch in remote_branches

def getAllRemoteBranches(rep):
    default_remotes_branches = []
    result = gitExec(rep, "git branch -r"
                     % locals())

    sbranch = re.compile(r'^([* ]) ([^/]+)/([^\s]*)')
    for line in result.splitlines():
        m = sbranch.match(line)
        if m:
            default = m.group(1)
            remote_ = m.group(2)
            branch = m.group(3)
            default_remotes_branches.append((default, remote_, branch))
            pass
        pass
    return default_remotes_branches

    
def getRemoteBranches(rep, remote):
    branches = []
    result = gitExec(rep, "git branch -r"
                     % locals())

    sbranch = re.compile(r'^([* ]) ([^/]+)/([^\s]*)')
    for line in result.splitlines():
        m = sbranch.match(line)
        if m:
            default = m.group(1)
            remote_ = m.group(2)
            branch = m.group(3)
            if remote_ == remote:
                branches.append(branch)
                pass
            pass
        pass
    return branches
    

def getLocalBranches(rep):
    branches = []
    result = gitExec(rep, "git branch"
                     % locals())

    sbranch = re.compile(r'^([* ]) ([^\s]*)')
    for line in result.splitlines():
        m = sbranch.match(line)
        if m:
            default = m.group(1)
            branch = m.group(2)
            branches.append(branch)
            pass
        pass
    return branches


def getRemoteUrl(rep,remote):
    result = gitExec(rep, "git config remote.%(remote)s.url"
                     % locals()).strip()
    return result

# def getLocalToPush(rep, remote, branch):
#     if not hasRemoteBranch(rep, remote, branch):
#         return []
#     result = gitExec(rep, "git log %(remote)s/%(branch)s..HEAD --oneline"
#                      % locals())

#     return [x for x in result.split('\n') if x]


# def getRemoteToPull(rep, remote, branch):
#     if not hasRemoteBranch(rep, remote, branch):
#         return []
#     result = gitExec(rep, "git log HEAD..%(remote)s/%(branch)s --oneline"
#                      % locals())

#     return [x for x in result.split('\n') if x]


def getLocalToPush(rep, remote, remote_branch, local_branch):
    if not hasRemoteBranch(rep, remote, remote_branch):
        return []
    result = gitExec(rep, "git log %(remote)s/%(remote_branch)s..%(local_branch)s --oneline -- "
                     % locals())

    return [x for x in result.split('\n') if x]


def getRemoteToPull(rep, remote, remote_branch, local_branch):
    if not hasRemoteBranch(rep, remote, remote_branch):
        return []
    result = gitExec(rep, "git log %(local_branch)s..%(remote)s/%(remote_branch)s --oneline -- "
                     % locals())

    return [x for x in result.split('\n') if x]


def updateRemote(rep):
    gitExec(rep, "git remote update")


# Get Default branch for repository
def getDefaultBranch(rep):
    curdir = os.path.abspath(os.getcwd())
    sbranch = re.compile(r'^\* (.*)')
    gitbranch = gitExec(rep, "git branch | grep '*'"
                        % locals())

    branch = ""
    m = sbranch.match(gitbranch)
    if m:
        branch = m.group(1)

    return branch


def getRemoteRepositories(rep):
    result = gitExec(rep, "git remote"
                     % locals())

    remotes = [x for x in result.split('\n') if x]
    return remotes


# Custom git command
def gitExecFull(rep, command):
    # curdir = os.path.abspath(os.getcwd())
    # cmd = "cd %(curdir)s/%(rep)s ; %(command)s" % locals()
    cmd = "cd %(rep)s ; %(command)s" % locals()
    #from subprocess import Popen, PIPE
    import subprocess
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE,shell=True)
    stdout, stderr = p.communicate()
    returncode = p.returncode
    return stdout,stderr,returncode

def gitExec(rep, command):
    # curdir = os.path.abspath(os.getcwd())
    # cmd = "cd %(curdir)s/%(rep)s ; %(command)s" % locals()
    cmd = "cd %(rep)s ; %(command)s" % locals()

    cmd = os.popen(cmd)
    return cmd.read()


# Check all git repositories
def gitcheck(args):
    repos = searchAllRepositories()
    
    for r in sorted(repos):
        if "git" in repos[r]:
            checkRepository(r, args)
        elif "svn" in repos[r]:
            if len(repos[r]) == 1:
                if IsInsideRepo(r,repos,"svn"):
                    continue
                pass
            if IsInsideRepo(r,repos,"git") or not IsInsideRepo(r,repos):
                print(r,":svn")
                pass
            pass
        else:
            print(r,"[No repo]")
            pass
        pass
    pass

def main():
    parser = argparse.ArgumentParser(description="Search for git repos and check for unpushed changes")
    parser.add_argument('-A','--all_branches', action='store_true', default=False, help='Check all local branches (not just the default branch)')
    parser.add_argument('-a','--all_output', action='store_true', default=False, help='print output for everything (even things that have no changes)')
    parser.add_argument('-v','--verbose', action='store_true', default=False, help='Show files & commits')
    parser.add_argument('-p','--pulls', action='store_true', default=False, help='show repos with pulls (instead of only ones with pushes)')
    parser.add_argument('-c','--clean', action='store_true', default=False, help='only show repos with problems')
    parser.add_argument('-r','--remote', action='store_true', default=False, help='force remote update(slow)')
    parser.add_argument('-f','--full-path', action='store_true', default=False, help='show full path for repos')
    parser.add_argument('-i','--ignore-branch', type=str, default=r'^$', help='ignore branches matching the regex <re>')
    args = parser.parse_args()

    gitcheck(args)

if __name__ == "__main__":
    main()
