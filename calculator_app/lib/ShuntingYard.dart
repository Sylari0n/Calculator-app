import 'dart:ffi';
import 'package:stack/stack.dart';


class ShuntingYard
{

  int getPrecedence(String ch)
  {
    if (ch == '+' || ch == '-')
      return 1;
    else if (ch == '*' || ch == '/')
      return 2;
    else if (ch == '^')
      return 3;
    else
      return -1;
  }

  bool hasLeftAssociativity(String ch)
  {
    if (ch == '+' || ch == '-' || ch == '/' || ch == '*')
      return true;
    else
      return false;
  }

  bool isNumeric(String s) {
  if (s == null || s == ".") {
    return false;
  }
  return double.tryParse(s) != null;
  }


  List<String> stringParser(String str)
  {
    String tmp = "";
    List<String> strArr = [];

    for (int i = 0; i < str.length; i++)
    {
      if (hasLeftAssociativity(str[i]))
      {
        if (tmp != "")
        {
          strArr.add(tmp);
        }
        strArr.add(str[i]);
        tmp = "";
      }
      else if (str[i] == '(')
      {
        strArr.add(str[i]);
      }
      else if (str[i] == ")")
      {
        if (tmp != "")
        {
          strArr.add(tmp);
          tmp = "";
        }
        strArr.add(str[i]);
      }
      else if (i == str.length-1)
      {
        tmp += str[i];
        strArr.add(tmp);
      }
      else
      {
        if (isNumeric(str[i]) || str[i] == '.')
        {
          tmp += str[i];
        }
      }
    }
    return strArr;
  }

  double mergeRpn(List<String> strArr)
  {
    Stack<double> stack = Stack();
    for (int i = 0; i < strArr.length; i++)
    {
      if (hasLeftAssociativity(strArr[i][0]) && stack.size() != 1)
      {
        double first = stack.pop();
        double second = stack.pop();
        switch(strArr[i][0])
        {
          case '+':
            stack.push(second + first);
            break;
          case '-':
            stack.push(second - first);
            break;
          case '*':
            stack.push(second * first);
            break;
          case '/':
            stack.push(second / first);
            break;
        }
      }
      else
      {
        stack.push(double.parse(strArr[i]));
      }
    }
    return stack.pop();
  }

  double intfixToRpn(String expression)
  {
    List<String> strArr = stringParser(expression);
    Stack<String> stack = Stack();

    List<String> output = [];

    for (int i = 0; i < strArr.length; i++)
    {
      String c = strArr[i];

      if (isNumeric(c[0]))
        output.add(c);
      
      else if (c[0] == '(')
        stack.push(c);
      
      else if (c[0] == ')')
      {
        while (!stack.isEmpty && stack.top()[0] != '(')
          output.add(stack.pop());
        
        stack.pop();
      }

      else
      {
        while (!stack.isEmpty && getPrecedence(c[0]) <= getPrecedence(stack.top()[0]) && hasLeftAssociativity(c[0]))
        {
          output.add(stack.pop());
        }
        stack.push(c);
      }
    }

    while(!stack.isEmpty)
    {
      if (stack.top()[0] == '(')
      {
        return -1;
      }
      output.add(stack.pop());
    }

    return mergeRpn(output);
  }
}