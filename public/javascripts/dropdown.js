//Main function to generate the drop down menu
function dropDown(targetEl, resultsEl, actionButton, callbackFunction)
{
	//assign the object
	objTarget = document.getElementById(targetEl);

	//hide the drop down by default
	hideDropDown(targetEl);

	//assign the button click to open/hide the dropdown
	assignButtonClick(objTarget, actionButton)

	//assign click functionality to each of individual child nodes
	assignChildNodeClick(objTarget, targetEl, resultsEl, callbackFunction)

	//create a hidden element on the document
	if(!document.getElementById('openDropDown'))
	{
		var hiddenElement = document.createElement('input');
		hiddenElement.setAttribute('type', 'hidden');
		hiddenElement.setAttribute('id', 'openDropDown');
		document.body.appendChild(hiddenElement);
	}
}

//function to hide the drop down menu.
function hideDropDown(target)
{
	objEL = document.getElementById(target);

	if(objEL)
	{
		if(objEL.style.display == 'block' || !objEL.style.display)    
		{
			objEL.style.display = 'none';
		}
	}
	else
	{
		alert('There is some problem with drop down with id : ' + target);
	}
}

//this function will bind the click event to show/hide the drop down
function assignButtonClick(target, actionButtonID)
{
	actionButton = document.getElementById(actionButtonID);
	actionButton.onclick = function() {
		currentOpenDD = document.getElementById('openDropDown').value
		if(currentOpenDD != '' && currentOpenDD == (target.id + ';;' + actionButtonID))
		{
			document.getElementById('openDropDown').value = '';
		}
		else if(currentOpenDD != '')
		{
			values = currentOpenDD.split(';;')
			hideDropDown(values[0])
			document.getElementById('openDropDown').value = target.id + ';;' + actionButtonID;
		}
		else
		{
			document.getElementById('openDropDown').value = target.id + ';;' + actionButtonID;
		}

		if(target.style.display == 'block' || !target.style.display)  
		{
			target.style.display = 'none';
		}
		else
		{
			target.style.display = 'block';
		}
	}
}

//function will bind each of the child nodes with the function to process clicks
function assignChildNodeClick(target, targetEl, resultsEl, callback)
{
	arrListElements = target.getElementsByTagName('LI');
	for(i=0;i<arrListElements.length;i++)
	{
		arrAnchorChild = arrListElements[i].getElementsByTagName('A');
		for(j=0; j<arrAnchorChild.length;j++)
		{
			currentNode = arrAnchorChild[j];
			currentNode.onclick = function() {
				if(callback)
				{
					callback.call(this, this, resultsEl)
				}
				else
				{
					processClick(this, resultsEl)
				}
				hideDropDown(targetEl)
			}
		}
	}
}

//function to select the current value and mark it as selected
function processClick(objAnchor, resultsEl)
{
	document.getElementById(resultsEl).innerHTML = objAnchor.innerHTML;
}

//bind the click function on the window and call callback function on each click
if (window.document.addEventListener){
  window.document.addEventListener('click', captureClick, false);
} else if (window.document.attachEvent){
  window.document.attachEvent('onclick', captureClick);
}

//callback function. called on each click on window
function captureClick(e)
{
	//capture the target element on which click action is performed
	if (window.event)
	{
		target = window.event.srcElement;
	}
	else
	{
		target = e.target ? e.target : e.srcElement;
	}

	if(document.getElementById('openDropDown').value != '')
	{
		arrValues = document.getElementById('openDropDown').value.split(';;')

		if(!checkParent(target, arrValues[0]))
		{
			if(target.id != arrValues[1])
			{
				hideDropDown(arrValues[0])
				document.getElementById('openDropDown').value = '';
			}
		}
	}
}

function loadEvents()
{
	
	dropDown('deviceList', 'flexbox_results', 'flex_button');
	
}

function extraCallback()
{
	var objAnchor = arguments[0];
	var resultElement = arguments[1];
		
	arrListItems = objAnchor.parentNode.parentNode.getElementsByTagName('A');
	
	for(i=0; i<arrListItems.length;i++)
	{
		children = arrListItems[i].childNodes;
		if(children[0].nodeName == 'SPAN')
		{
			arrListItems[i].innerHTML = arrListItems[i].innerHTML.replace(/\<span\>/ig, '');
			arrListItems[i].innerHTML = arrListItems[i].innerHTML.replace(/\<\/span\>/ig, '')
		}
	}

	var originalHTML = objAnchor.innerHTML;
	objAnchor.innerHTML = '<span>' + originalHTML + '</span>';
	
	arrImgItems = document.getElementById(resultElement).getElementsByTagName('IMG');
	arrImgItems[0].src = arrImgItems[0].src.replace(/flag(.*).gif/ig, 'flag_' + objAnchor.className + '.gif');
}


function addMultipleLoadEvents(func)
{
	var oldonload = window.onload;
	if (typeof window.onload != 'function')
	{
		window.onload = func;
	}
	else
	{
		window.onload = function() {
			if (oldonload)
			{
				oldonload();
			}
			func();
		}
	}
}

function checkParent(objEl, parentID)
{
	if(objEl.parentNode.id == parentID)
	{
		return true;
	}
	else if(objEl.parentNode.nodeName == 'BODY')
	{
		return false;
	}
	else
	{
		return checkParent(objEl.parentNode, parentID);
	}
}

addMultipleLoadEvents(loadEvents)